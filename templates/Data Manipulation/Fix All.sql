--Replace <DATABASE_NAME> and <TABLE_NAME>

DECLARE  
@col nvarchar(100) ,
@sql varchar(5000) 


DECLARE action CURSOR FOR 
select 
	column_name from <DATABASE_NAME>.INFORMATION_SCHEMA.columns
where table_name='<TABLE_NAME>'
order by ordinal_position


OPEN action 
FETCH NEXT FROM action INTO @col
WHILE @@FETCH_STATUS = 0 

BEGIN 
	-- replace NULL with ''
	set @col='[' + @col + ']'
	set @sql='UPDATE <TABLE_NAME> set ' + 	@col + '=' + '''''' + ' where ' + @col + ' is null;'
	execute (@sql)
	
	--remove CRLF
	set @sql='UPDATE <TABLE_NAME> set ' + 	@col + '=' + 
	'REPLACE(REPLACE(REPLACE(' + @col + ', CHAR(10), ' +  '''''' +'), CHAR(13), ' + '''''' + '), CHAR(9), ' + '''''' + ')'
	execute (@sql)
	
	-- Get rid if single quotes
	set @sql='UPDATE <TABLE_NAME> set ' + 	@col + '=' + 
	'REPLACE(' + @col + ',' + '''''''''' + ',' + '''''' + ')'
	execute (@sql)


FETCH NEXT 
	FROM 
		action 
	INTO @col

End 

Close action
DEALLOCATE action



