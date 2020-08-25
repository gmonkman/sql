select
	case
		when grouping(userprofile.username)=1 then '#DFEAFF'
		when grouping(year(date_from))=1  then '#FDE4AE'
		else '' end as colour
	,case 
		when grouping(userprofile.username)=1 then 'Total'
		when grouping(year(date_from))=1  then 'User total'
		else userprofile.username end as Username
	,year(date_from) as [year], sum(total_days) as [days] -- ,grouping(year(date_from)),grouping(userprofile.username)
from
	absence
	inner join userprofile on absence.userid=userprofile.userid
where
	userprofile.isapproved=1
group by userprofile.username,year(date_from) with rollup