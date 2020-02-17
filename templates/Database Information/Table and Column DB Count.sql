select count(*)
from information_schema.columns

select count(*)
from
(
select distinct

	table_name from information_schema.columns
) as x