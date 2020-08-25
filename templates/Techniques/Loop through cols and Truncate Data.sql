/* TRUNCATE DATA AUTOMATICALLY */
DECLARE  
@col nvarchar(100),
@sql varchar(5000) ,
@l smallint

DECLARE action CURSOR FOR 
select 
	column_name,isnull(character_maximum_length,0) as length 
from p2_telford.INFORMATION_SCHEMA.columns
where 
	(table_name='equipment'
	or table_name='equipment_activity')
	and (
	column_name='reference' or
 column_name='equipmentsubtype' or
 column_name='manufacturer' or
 column_name='model_number' or
 column_name='serialnumber' or
 column_name='description' or
 column_name='location' or
 column_name='costcode' or
 column_name='FILE_REFERENCE' or
 column_name='comments' or
 column_name='activity' or
 column_name='activity_description' or
 column_name='notes'
 )
	and data_type like '%char%'
order by ordinal_position
	
OPEN action 
FETCH NEXT FROM action INTO @col,@l
WHILE @@FETCH_STATUS = 0 

BEGIN 
	set @col='[' + @col + ']'
	set @sql='UPDATE p2_telford..import_equipment set ' + 	@col + '=left(' + @col + ',' + CAST(@l as varchar)  + ');'
	execute (@sql)
	--print @sql
	
FETCH NEXT 
	FROM 
		action 
	INTO @col,@l

End 

Close action
DEALLOCATE action