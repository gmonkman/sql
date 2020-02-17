

DECLARE  
	@keytable varchar(250),
	@keycolumn varchar(250),
	@keytextcolumn varchar(250),
	@fktable varchar(250),
	@fkcolumn varchar(250),
	@newval varchar(250),
	@oldval varchar(250),
	@sql varchar(8000)

set @keytable=''
set @keycolumn=''

	'update ' + @fktablesit + " set " + @fkcolumn + "=(Select top 1 " + @keycolumn + 
		' from ' + @keytable + ' where ' + @keytextcolumn + '=' + @keytextcolumn + ') where ' +
	@fkcolumn + '=(select top 1 ' + fkcolumn + '  from ' + @keysitetype where sitetype='yy')	
	
DECLARE action CURSOR FOR 
	select 
		table_name,column_name from information_schema.columns
	where 
		column_name = @keycolumn
		and table_name not like 'v_%'
		and table_name <> @keytable
	order by 
		table_name,column_name
	

OPEN action 
FETCH NEXT FROM action INTO @keytable,@keycolumn
WHILE @@FETCH_STATUS = 0 

BEGIN 
	set @sql='update ' + @fktable  + ' set ' + @keycolumn + '=(select '
	
	

	
	exec sp_executesql @sql
FETCH NEXT 
	FROM 
		action 
	INTO @keytable,@keycolumn

End 

Close action
DEALLOCATE action
