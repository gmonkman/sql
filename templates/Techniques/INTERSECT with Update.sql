
UPDATE os_open_name SET coast_dist_m = -1
where os_open_name.os_open_nameid
in
(
select top 715791
	os_open_nameid
from
	os_open_name
intersect
select top 715791
	os_open_nameid
from
	os_open_name
where
	coast_dist_m is null
order by
	os_open_nameid
)

