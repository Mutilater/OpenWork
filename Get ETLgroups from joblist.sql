
WITH job_list as(
	SELECT 'J_GLOBAL_GROUP_1' AS job_name
	, 'begin
	pck_etl.start_group( 12  );
    pck_etl.start_group( p_etl_group=>15, p_debug_mode=>5 );
	pck_etl_mgmt.p_start_group(   34);
	pck_etl_mgmt.p_start_group(38    )    ;
    pck_etl_mgmt.p_start_group(in_etl_group=>45, in_debug_mode=>5)    ;
	pck_etl.start_group( 13  );
    pck_etl.start_group( 14  );
  pck_etl.start_group( 16  );
 pck_etl.start_group( 17  );
	end; ' AS job_action	 
	FROM dual
	UNION ALL
	SELECT  'J_GLOBAL_GROUP_21' AS job_name
	, 'begin
	pck_etl.start_group( 22  );
    pck_etl.start_group( p_etl_group=>115, p_debug_mode=>5 );
	pck_etl_mgmt.p_start_group(   123);
	pck_etl_mgmt.p_start_group(3289    )    ;
    pck_etl_mgmt.p_start_group(in_etl_group=>435, in_debug_mode=>5)    ;
    pck_etl.start_group( 211  );
    pck_etl.start_group( 213  );
	pck_etl.start_group( 214  );
	end; ' AS job_action	 
	FROM dual
	UNION ALL
	SELECT  'J_GLOBAL_GROUP_31' AS job_name
	, 'begin
	pck_etl.start_group( 32  );

	pck_etl_mgmt.p_start_group(   123);
	pck_etl_mgmt.p_start_group(3289    )    ;
	pck_etl.start_group( 350  );
    pck_etl.start_group( 32313  );
	end; ' AS job_action	 
	FROM dual
	
), start_group_list AS (
	SELECT 'OLD' AS etl_type, j.*, r.* FROM job_list j
	CROSS APPLY (
		SELECT    REGEXP_SUBSTR(lower(job_action), '(\.start_group\(\s*\d+\s*\)\s*;)', 1, LEVEL, 'x', 1) AS start_group_str	 
		FROM (SELECT * FROM job_list WHERE job_name=j.job_name)
		CONNECT BY LEVEL<=regexp_count(lower(job_action), '(\.start_group\(\s*\d+\s*\)\s*;)')
	) r
	UNION ALL
	SELECT 'NEW' AS etl_type, j.*, r.* FROM job_list j
	CROSS APPLY (
		SELECT    REGEXP_SUBSTR(lower(job_action), '(\.p_start_group\(\s*\d+\s*\)\s*;)', 1, LEVEL, 'x', 1) AS start_group_str	 
		FROM (SELECT * FROM job_list WHERE job_name=j.job_name)
		CONNECT BY LEVEL<=regexp_count(lower(job_action), '(\.p_start_group\(\s*\d+\s*\)\s*;)')
	)r
)
SELECT s.etl_type , s.job_name , s.start_group_str 
, REGEXP_REPLACE(start_group_str, '(\D)', '') AS etl_group
FROM start_group_list s
ORDER BY job_name --, etl_type
/* Output
OLD	J_GLOBAL_GROUP_1	.start_group( 13  );	13
NEW	J_GLOBAL_GROUP_1	.p_start_group(   34);	34
OLD	J_GLOBAL_GROUP_1	.start_group( 17  );	17
OLD	J_GLOBAL_GROUP_1	.start_group( 16  );	16
OLD	J_GLOBAL_GROUP_1	.start_group( 14  );	14
NEW	J_GLOBAL_GROUP_1	.p_start_group(38    )    ;	38
OLD	J_GLOBAL_GROUP_1	.start_group( 12  );	12
NEW	J_GLOBAL_GROUP_21	.p_start_group(3289    )    ;	3289
OLD	J_GLOBAL_GROUP_21	.start_group( 213  );	213
OLD	J_GLOBAL_GROUP_21	.start_group( 22  );	22
OLD	J_GLOBAL_GROUP_21	.start_group( 211  );	211
OLD	J_GLOBAL_GROUP_21	.start_group( 214  );	214
NEW	J_GLOBAL_GROUP_21	.p_start_group(   123);	123
OLD	J_GLOBAL_GROUP_31	.start_group( 32  );	32
OLD	J_GLOBAL_GROUP_31	.start_group( 350  );	350
OLD	J_GLOBAL_GROUP_31	.start_group( 32313  );	32313
NEW	J_GLOBAL_GROUP_31	.p_start_group(3289    )    ;	3289
NEW	J_GLOBAL_GROUP_31	.p_start_group(   123);	123
  */

--After join etl_table_list for get  flow/worker/order/src_full_name/dest_full_name/full_proc_name
--And let's ok!
--Enjoy!


--SELECT dsj. FROM DBA_SCHEDULER_JOBS dsj 


