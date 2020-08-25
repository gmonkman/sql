with
	cte as (select our_rank,[rank], count(*) as n, abs(our_rank-rank) as dist
	from survey_activity
	where not rank is null and not our_rank is null
	group by our_rank,[rank]
	),
	tot as (select count(*) as tot from survey_activity
	where not rank is null and not our_rank is null
	)
select
	DIST
	,SUM(N)
	,(sum(n) / cast(tot as float)) * 100
	,SUM((sum(n) / cast(tot as float)) * 100) OVER(ORDER BY DIST ROWS UNBOUNDED PRECEDING ) as cum
from cte, tot
group by dist,tot
order by dist asc