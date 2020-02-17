/*
SAMPLE DATA

election_year	electoral_wardid	n		age_range
2017					Aethwy ED					643	0-9
2017					Aethwy ED					705	10-19
2017					Aethwy ED					713	20-29
2017					Aethwy ED					770	30-39
*/

create view v_demographics_pvt as
(
select
	election_year
	,electoral_wardid
	,[0-9],[10-19],[20-29],[30-39],[40-49],[50-59],[60-69],[70-79],[80-89],[90+]
from
	(select election_year, electoral_wardid, n, age_range from v_demographics_range) as src
PIVOT
	(
		max(n) for age_range IN ([0-9],[10-19],[20-29],[30-39],[40-49],[50-59],[60-69],[70-79],[80-89],[90+])
	) as pvt
	)


	select * from v_demographics_pvt