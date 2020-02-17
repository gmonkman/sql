DECLARE    
	@colname varchar(50),	
	@sql varchar(8000),
	@tblname varchar(50),
	@datatype varchar(20)
		
	set @tblname='sample_length'
	set @sql = 'INSERT INTO ' + @tblname + ' ( '

DECLARE action CURSOR FOR 
		select 
			column_name,data_type
		from 
			information_schema.columns
		where	
			table_name=@tblname
		order by ordinal_position


OPEN action 
FETCH NEXT FROM action INTO @colname,@datatype
WHILE @@FETCH_STATUS = 0 

BEGIN 
	set @colname='[' + @colname + ']'  + CHAR(13)
	set @sql=@sql + @colname + ','

FETCH NEXT 
	FROM 
		action 
	INTO @colname,@datatype

End 

set @sql=left(@sql,len(@sql)-1)
set @sql=@sql + ' ) SELECT '



Close action
DEALLOCATE action

print @sql