INSERT INTO [dbo].[vb_tbl_trigger](
	trigger_name,
	created_user,
	created_date,
	updated_user,
	updated_date
)
VALUES
('Tr_sample_csv','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
('Tr_sample_excel','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
('Tr_sample_restApi','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
('Tr_sample_sql','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
('Tr_sample_sftp','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
('Tr_sample_snowflake','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
('Tr_sample_json','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
('Tr_sample_bulk','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30');

INSERT INTO [dbo].[vb_tbl_job](
	trigger_id,
	L2_switch_type,
	L3_switch_type,
	L4_switch_type,
	created_user,
	created_date,
	updated_user,
	updated_date
)
VALUES
(1, 'CloudStorage','Azure','csv','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(2, 'CloudStorage','Azure','excel','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(3, 'API','','','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(4, 'sql','','','Tushar Jadhav','2025-06-30','Tushar Jadhav','2025-06-30'),
(5, 'sftp','','','Tushar Jadhav','2025-06-30','Tushar Jadhav','2025-06-30'),
(6, 'snowflake','','','Tushar Jadhav','2025-06-30','Tushar Jadhav','2025-06-30'),
(7, 'json','','','Tushar Jadhav','2025-06-30','Tushar Jadhav','2025-06-30'),
(8, 'bulk','','','Tushar Jadhav','2025-06-30','Tushar Jadhav','2025-06-30');

INSERT INTO [dbo].[vb_tbl_job_dtls](
	jobid,
	dtls_key,
	dtls_value,
	created_user,
	created_date,
	updated_user,
	updated_date
)
VALUES
(1,'delimter',',','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(1,'sourcedata','https://adlsdevvisionboardraw01.dfs.core.windows.net/','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(1,'SourceFile','orders_dataset.csv','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(1,'targetdata','https://adlsdevvbsrc01.dfs.core.windows.net/','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(1,'targetdirectory', 'csvcloud','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),

(2,'sheetname', 'products_dataset','Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(2,'sourcedata','https://adlsdevvisionboardraw01.dfs.core.windows.net/', 'Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(2,'SourceFile','products_dataset.xlsx', 'Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(2,'targetdata','https://adlsdevvbsrc01.dfs.core.windows.net/', 'Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30'),
(2,'targetdirectory', 'excelcloud', 'Tushar Jadhav','2025-08-30','Tushar Jadhav','2025-08-30');
