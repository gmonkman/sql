--select dbo.fGenerateSQLSelectSIMPLE('v_project_lookups',1,0)

alter function fGenerateSQLSelectSIMPLE
(
	@tablename varchar(50),@exclude_guids bit,@ordinal_order bit
)
returns varchar(8000)
as
BEGIN

DECLARE    
	@colname varchar(50)
	,@datatype varchar(50)
	,@sql varchar(8000)
	
		
	set @sql = 'SELECT '

if @ordinal_order=0 
	DECLARE action CURSOR FOR 
			select 
				column_name,data_type
			from 
				information_schema.columns
			where	
				table_name=@tablename
			order by column_name
else
	DECLARE action CURSOR FOR 
			select 
				column_name,data_type
			from 
				information_schema.columns
			where	
				table_name=@tablename
			order by ordinal_position
			

OPEN action 
FETCH NEXT FROM action INTO @colname,@datatype
WHILE @@FETCH_STATUS = 0 

BEGIN 
	set @colname='[' + @colname + ']'
	if @exclude_guids=1 and charindex('unique',@datatype)>0
		set @sql = @sql + ''
	else
			set @sql = @sql + @colname + ','	 

 

FETCH NEXT 
	FROM 
		action 
	INTO @colname,@datatype

End 

	set @sql=ltrim(rtrim(@sql))
	set @sql=replace(@sql,',,',',')
	if right(@sql,1)=',' set @sql=left(@sql,len(@sql)-1)
	set @sql=@sql + ' FROM ' + @tablename

Close action
DEALLOCATE action

return @sql
END