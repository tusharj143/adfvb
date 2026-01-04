create table dbo.vb_tbl_trigger(
trigger_id int identity(1,1) primary key,
trigger_name varchar(250),
created_user varchar(50),
created_date datetime,
updated_user varchar(50),
updated_date datetime
);

create table dbo.vb_tbl_job(
jobid int identity(1,1) primary key,
trigger_id int FOREIGN KEY REFERENCES vb_tbl_trigger(trigger_id),
L2_switch_type varchar(50),
L3_switch_type varchar(50),
L4_switch_type varchar(50),
created_user varchar(50),
created_date datetime,
updated_user varchar(50),
updated_date datetime
);

CREATE TABLE vb_tbl_job_dtls(
job_dtls_id int identity(1,1) PRIMARY KEY,
jobid int FOREIGN KEY REFERENCES vb_tbl_job(jobid),
dtls_key varchar(100),
dtls_value varchar(MAX),
created_user varchar(50),
created_date datetime,
updated_user varchar(50),
updated_date datetime
);

create table dbo.vb_tbl_log_dtls(
log_id int identity(1,1) PRIMARY KEY,
jobid int FOREIGN KEY REFERENCES vb_tbl_job(jobid),
pipeline_id varchar(100),
job_start_time datetime,
job_end_time datetime,
job_status varchar(10),
error_dtls varchar(Max),
created_user varchar(50),
created_date datetime,
updated_user varchar(50),
updated_date datetime
);

CREATE PROCEDURE dbo.vb_start_log_entry
@jobid int,
@pipeline_id varchar(100)
AS
BEGIN
INSERT INTO [dbo].[vb_tbl_log_dtls]
(jobid, pipeline_id, job_start_time, job_status, created_user, created_date, updated_user, updated_date)
SELECT @jobid, @pipeline_id, getdate(), 'Running', system_user, getdate(), system_user, getdate()
END


CREATE PROCEDURE dbo.vb_end_log_entry
@jobid int,
@pipeline_id varchar(100),
@error varchar(max)
AS
BEGIN
UPDATE [dbo].[vb_tbl_log_dtls]
SET job_end_time = getdate(),
	job_status = CASE WHEN @error IS NULL THEN 'Completed' ELSE 'Failed' END,
	error_dtls = @error
WHERE jobid = @jobid AND pipeline_id = @pipeline_id
END


CREATE PROCEDURE dbo.vb_get_job_dtls
@TriggerName varchar(50)
AS
BEGIN
--DECLARE @TriggerName varchar(50) = 'Tr_sample_csv'

DECLARE @cols AS NVARCHAR(MAX),  --Variable to store dynamic list of column names
	@query AS NVARCHAR(MAX)      --Variable to store dynamic sql query

SET @cols =
(
	SELECT STRING_AGG(dtls_key,',')  --Outer SELECT takes that list and combines it into a single string
	FROM 
	(
		SELECT DISTINCT QUOTENAME(dtls_key) AS dtls_key  --Inner SELECT gets the list of unique column names
		FROM [dbo].[vb_tbl_trigger] a
		JOIN [dbo].[vb_tbl_job] b ON a.trigger_id = b.trigger_id
		JOIN [dbo].[vb_tbl_job_dtls] c ON b.jobid = c.jobid
		WHERE a.trigger_name = @TriggerName
	)str_agg
)

set @query = N'
SELECT trigger_name, jobid, L2_switch_type, L3_switch_type, L4_switch_type, ' + @cols + N'
FROM
(
	SELECT dtls_value, dtls_key, a.trigger_name, b.jobid, L2_switch_type, L3_switch_type, L4_switch_type
	FROM dbo.vb_tbl_trigger a
	JOIN dbo.vb_tbl_job b ON a.trigger_id = b.trigger_id
	JOIN dbo.vb_tbl_job_dtls c ON b.jobid = c.jobid
	WHERE a.trigger_name = '''+ @TriggerName +'''
)x
PIVOT
(
	MAX(dtls_value)
	FOR dtls_key IN (' + @cols + N')
)p'

EXEC sp_executesql @query;

END


CREATE OR ALTER PROCEDURE dbo.vb_get_job_dtls
    @TriggerName varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @cols  AS NVARCHAR(MAX),  -- dynamic list of column names
            @query AS NVARCHAR(MAX);  -- dynamic SQL

    -- Build list of dtls_key columns for this trigger
    SET @cols =
    (
        SELECT STRING_AGG(dtls_key, ',')
        FROM
        (
            SELECT DISTINCT QUOTENAME(dtls_key) AS dtls_key
            FROM [dbo].[vb_tbl_trigger] a
            JOIN [dbo].[vb_tbl_job] b
                ON a.trigger_id = b.trigger_id
            JOIN [dbo].[vb_tbl_job_dtls] c
                ON b.jobid = c.jobid
            WHERE a.trigger_name = @TriggerName
        ) str_agg
    );

    -------------------------------------------------------------------
    -- If no detail rows exist for this trigger, return basic info only
    -------------------------------------------------------------------
    IF @cols IS NULL
    BEGIN
        SELECT TOP (1)
               a.trigger_name,
               b.jobid,
               b.L2_switch_type,
               b.L3_switch_type,
               b.L4_switch_type
        FROM dbo.vb_tbl_trigger a
        JOIN dbo.vb_tbl_job b
            ON a.trigger_id = b.trigger_id
        WHERE a.trigger_name = @TriggerName;

        RETURN;
    END;

    -----------------------------------------------
    -- Normal dynamic PIVOT when details do exist
    -----------------------------------------------
    SET @query = N'
    SELECT trigger_name,
           jobid,
           L2_switch_type,
           L3_switch_type,
           L4_switch_type,
           ' + @cols + N'
    FROM
    (
        SELECT  dtls_value,
                dtls_key,
                a.trigger_name,
                b.jobid,
                L2_switch_type,
                L3_switch_type,
                L4_switch_type
        FROM dbo.vb_tbl_trigger a
        JOIN dbo.vb_tbl_job b
            ON a.trigger_id = b.trigger_id
        JOIN dbo.vb_tbl_job_dtls c
            ON b.jobid = c.jobid
        WHERE a.trigger_name = ''' + @TriggerName + '''
    ) x
    PIVOT
    (
        MAX(dtls_value)
        FOR dtls_key IN (' + @cols + N')
    ) p';

    EXEC sp_executesql @query;
END;

EXEC dbo.vb_get_job_dtls @TriggerName = 'Tr_sample_excel';  -- your Excel trigger
