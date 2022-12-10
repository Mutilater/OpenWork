
WITH job_list as(
	SELECT 'begin
	pck_etl.start_group( 10  );
    pck_etl.start_group( p_etl_group=>15, p_debug_mode=>5 );
	pck_etl_mgmt.p_start_group(   34);
	pck_etl_mgmt.p_start_group(38    )    ;
    pck_etl_mgmt.p_start_group(in_etl_group=>45, in_debug_mode=>5)    ;
	end; ' AS job_action
	 
	FROM dual
	
), start_group_list AS (

SELECT 'OLD' AS etl_type, REGEXP_SUBSTR(lower(job_action), '(\.start_group\(\s*\d+\s*\)\s*;)', 1, rownum, 'c', 1) AS start_group_str	 
FROM job_list
CONNECT BY LEVEL<=regexp_count(lower(job_action), '(\.start_group\(\s*\d+\s*\)\s*;)')
UNION ALL

SELECT 'NEW' AS etl_type, REGEXP_SUBSTR(lower(job_action), '(\.p_start_group\(\s*\d+\s*\)\s*;)', 1, rownum, 'c', 1) AS start_group_str	 
FROM job_list
CONNECT BY LEVEL<=regexp_count(lower(job_action), '(\.p_start_group\(\s*\d+\s*\)\s*;)')
)
SELECT etl_type
, REGEXP_REPLACE(start_group_str, '(\D)', '') AS etl_group
FROM start_group_list
/* Вывод
OLD	10
NEW	34
NEW	38
  */

--Дальше джойним настройки ETL для получения  потоков/воркеров/порядка/источников/ приемников и к ним уже джойним логи за определенный интервал
--Вот и готова простейшая система мониторинга
--Дальше будем дорабатывать



