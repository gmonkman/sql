select 
	table_name,column_name,data_type,isnull(character_maximum_length,0) as length from information_schema.columns
where column_name = 'status_code'
order by table_name,column_name

select 
	table_name,column_name,data_type,isnull(character_maximum_length,0) as length from information_schema.columns
where table_name='TEMPLATE_CHECKLISTTYPE'
order by ordinal_position

