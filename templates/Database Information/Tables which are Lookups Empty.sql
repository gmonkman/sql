SET NOCOUNT ON
    DECLARE @SQL VARCHAR(255) 
    SET @SQL = 'DBCC UPDATEUSAGE (' + DB_NAME() + ')' 
    EXEC(@SQL)
    CREATE TABLE #foo  (tablename VARCHAR(255),   rc INT, fk varchar(255)) 
go
INSERT #foo
		EXEC sp_msForEachTable  'SELECT PARSENAME(''?'', 1) ,  COUNT(*),null FROM ?' 
go

update #foo set fk=tablename + 'ID'
go

delete from #foo where rc>0
go

select tablename,column_name,count(*) as use_count
from
#foo
inner join
(
select 
	table_name,column_name,data_type,isnull(character_maximum_length,0) as length from information_schema.columns
where 
	column_name like  '%id'
	and table_name + 'id' <> column_name
) as x
on #foo.fk=x.column_name
group by tablename,column_name

drop table #foo



