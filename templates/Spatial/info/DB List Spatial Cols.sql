/*SIMPLE */
select schema_name(t.schema_id) + '.' + t.name as [table],
       c.column_id,
       c.name as column_name,
       type_name(user_type_id) as data_type
from sys.columns c
join sys.tables t
     on t.object_id = c.object_id
where type_name(user_type_id) in ('geometry', 'geography')
order by [table],
         c.column_id;