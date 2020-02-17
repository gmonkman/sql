
drop table foo
go

SET NOCOUNT ON
    DECLARE @SQL VARCHAR(255) 
    SET @SQL = 'DBCC UPDATEUSAGE (' + DB_NAME() + ')' 
    EXEC(@SQL)
    CREATE TABLE foo  (tablename VARCHAR(255),   rc INT)    
    INSERT foo EXEC sp_msForEachTable  'SELECT PARSENAME(''?'', 1),  COUNT(*) FROM ?' 
    SELECT tablename, rc    FROM foo   ORDER BY rc DESC 
go

   
create view V_DATABASE_LAST_ACCESS as
WITH agg AS
(
    SELECT
        [object_id],
        last_user_seek,
        last_user_scan,
        last_user_lookup,
        last_user_update
    FROM
        sys.dm_db_index_usage_stats
    WHERE
        database_id = DB_ID()
)
SELECT
    [Schema] = OBJECT_SCHEMA_NAME([object_id]),
    [Table_Or_View] = OBJECT_NAME([object_id]),
    last_read = MAX(last_read),
    last_write = MAX(last_write)
FROM
(
    SELECT [object_id], last_user_seek, NULL FROM agg
    UNION ALL
    SELECT [object_id], last_user_scan, NULL FROM agg
    UNION ALL
    SELECT [object_id], last_user_lookup, NULL FROM agg
    UNION ALL
    SELECT [object_id], NULL, last_user_update FROM agg
) AS x ([object_id], last_read, last_write)
GROUP BY
    OBJECT_SCHEMA_NAME([object_id]),
    OBJECT_NAME([object_id])
--ORDER BY 1,2;
go

select 
	V_DATABASE_LAST_ACCESS.*
	,foo.rc
From 
	V_DATABASE_LAST_ACCESS
	inner join foo on V_DATABASE_LAST_ACCESS.table_or_view=foo.tablename
where 
	not last_write is null and last_write between  '2012 June 03 00:01' and '2012 June 03 23:00'
	--and foo.rc>2
	
	select * from site_dec
	
	select * from cluster
	select * from foo order by rc desc
	
	select * from subclient
	
	select * from changetype
	
	select input_date from site

select * from import_sites
select * from site_managedby


select * from ward