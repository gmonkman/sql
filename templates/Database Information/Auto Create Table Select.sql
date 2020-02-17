DECLARE    
	@colname varchar(50),	
	@sql varchar(8000),
	@sep char(1),
	@tblname varchar(50),
	@datatype varchar(20)
		
	set @sep='^'
	set @tblname='Tbl_BP_Roles_SAP_Export'
	set @sql = 'SELECT'
	
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
	set @colname='[' + @colname + ']'
	if charindex('int',@datatype)>0
		set @sql = @sql + ' isnull(' +  'cast(' + @colname + ' as varchar(20))' + ','''') + ' + '''' + @sep + '''' + ' +'		 
	else if CHARINDEX('bit',@datatype)>0
		set @sql = @sql + ' isnull(' +  'cast(' + @colname + ' as varchar(20))' + ','''') + ' + '''' + @sep + '''' + ' +'		 
	else 
		set @sql = @sql + ' isnull(' +  @colname + ','''') + ' + '''' + @sep + '''' + ' +'
 

FETCH NEXT 
	FROM 
		action 
	INTO @colname,@datatype

End 

set @sql = left(@sql,len(@sql) - 7)
set @sql=@sql + ' as records '
set @sql=@sql + ' FROM ' + @tblname


Close action
DEALLOCATE action

print @sql