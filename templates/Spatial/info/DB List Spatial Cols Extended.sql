/* This lists tables with spatial data, with the col names
and the feature types and reports if any of the features
in the tables have an invalid geometry
*/

use gazetteer
go

drop table ##temp
create table ##temp
(
	tbl varchar(250)
	,column_id int
	,column_name varchar(250)
	,data_type varchar(50)
	,feature_type varchar(50) null
	,valid int
	,nr int
)

insert into ##temp
select schema_name(t.schema_id) + '.' + t.name as [tbl],
       c.column_id,
       c.name as column_name,
       type_name(user_type_id) as data_type,
			 null,
			 0,
			 0
from sys.columns c
join sys.tables t
     on t.object_id = c.object_id
where 
	type_name(user_type_id) in ('geometry', 'geography')
	--and t.name='mytable'
order by [tbl],
         c.column_id

DECLARE 
	@tbl varchar(250)
	,@column_name varchar(250)
	,@sql varchar(2000)
	,@tbl_strip varchar(250)

DECLARE action CURSOR FOR 
	SELECT tbl, column_name FROM ##temp
OPEN action 
FETCH NEXT FROM action INTO @tbl, @column_name

WHILE @@FETCH_STATUS = 0 
	BEGIN
		set @tbl_strip = replace(@tbl, 'dbo.', '')
		set @sql = 'UPDATE ##temp SET feature_type=(SELECT TOP 1 ' + @tbl_strip + '.' + @column_name + '.MakeValid().STGeometryType() FROM ' + @tbl + ') WHERE tbl=' + '''' + @tbl + '''' + ' AND column_name=' + '''' + @column_name + '''' + ';'
		--print @sql
		execute(@sql)

		set @sql = 'UPDATE ##temp SET valid=(SELECT min(cast(' + @tbl_strip + '.' + @column_name  + '.STIsValid() as int)) FROM ' + @tbl + ') WHERE tbl=' + '''' + @tbl + '''' + ' AND column_name=' + '''' + @column_name + '''' + ';'
		--print @sql
		execute(@sql)

		set @sql = 'UPDATE ##temp SET nr=(SELECT count(*) FROM ' + @tbl + ') WHERE tbl=' + '''' + @tbl + '''' + ';'
		--print @sql
		execute(@sql)
		

	FETCH NEXT 
		FROM 
			action 
		INTO @tbl, @column_name
	END



Close action
DEALLOCATE action

select * from ##temp
order by tbl
