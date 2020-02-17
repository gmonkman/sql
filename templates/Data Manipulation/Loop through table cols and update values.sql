DECLARE  
	@col nvarchar(100) ,
	@sql varchar(5000) 


DECLARE action CURSOR FOR 
select 
	column_name from p2_telford.INFORMATION_SCHEMA.columns
where table_name='import_equipment'
order by ordinal_position


OPEN action 
FETCH NEXT FROM action INTO @col
WHILE @@FETCH_STATUS = 0 

BEGIN 
	set @col='[' + @col + ']'
	set @sql='UPDATE p2_telford..import_equipment set ' + 	@col + '=' + '''''' + ' where ' + @col + ' is null;'
--print @sql
	 execute (@sql)



FETCH NEXT 
	FROM 
		action 
	INTO @col

End 

Close action
DEALLOCATE action
