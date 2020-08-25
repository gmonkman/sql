--Pure t-sql (Microsoft SQL Server) example of creating a distance matrix between points to identify and filter spatial outliers
/*
This creates a distance matrix between all gazetteer points within 
a single post (ugc), returning only the unique values (the 1/2 matrix)
*/

use mmo_final
go
select * from v_dist_mat

create view v_dist_mat
as
with midpts as
(
select 
	ug.ugcid
	,g.gazetteerid
	,geography::Point(y, x, 4326) as pt
from
	ugc_gaz ug
	inner join gazetteer_shore.dbo.gazetteer g on ug.gazetteerid=g.gazetteerid
)
select
	a.ugcid
	,a.gazetteerid as a_gazetteerid
	,b.gazetteerid as b_gazetteerid
	,a.pt.STDistance(b.pt) as dst
from
	midpts a, midpts b 
where a.ugcid=b.ugcid and a.pt.STDistance(b.pt) > 0 and b.gazetteerid > a.gazetteerid
--order by ugcid, a.gazetteerid, b.gazetteerid

/* taking the previous matrix, calculate the
mean distance between all points for a given
ugcid */
CREATE VIEW v_dist_mat_mean_diff
as
with cte as
(
select
	ugcid
	,avg(dst) as avg_dst
	,count(*) as n
from
	v_dist_mat
group by
	ugcid
)
select
	cte.ugcid
	,v_dist_mat.a_gazetteerid
	,v_dist_mat.b_gazetteerid
	,avg_dst
	,dst
	,v_dist_mat.dst - cte.avg_dst as diff_dst
	,n
from
	cte join v_dist_mat on cte.ugcid=v_dist_mat.ugcid


--create data as temporary table as the next query is extremely slow
select * into #v_dist_mat_mean_diff
from v_dist_mat_mean_diff
	
create clustered index cx_v_dist_mat_mean_diff on #v_dist_mat_mean_diff (ugcid, a_gazetteerid, b_gazetteerid);
create nonclustered index ix_tmp_ugc on #v_dist_mat_mean_diff (ugcid);
create nonclustered index ix_tmp_ugc1 on #v_dist_mat_mean_diff (a_gazetteerid);
create nonclustered index ix_tmp_ugc2 on #v_dist_mat_mean_diff (b_gazetteerid);

--select * from v_dist_mat_mean_diff
/* taking the mean distance matrix, calculate outliers
where an outlier has no distance between any other point
which is less than the mean in a given ugcid (post)
*/
;with inliers as
(
select distinct
	ugcid, a_gazetteerid as inliers
from
	#v_dist_mat_mean_diff
where diff_dst <= 0
union
select distinct
	ugcid, b_gazetteerid as inliers
from
	#v_dist_mat_mean_diff
where diff_dst <= 0	
),
outliers as
(
select distinct 
	ugcid, a_gazetteerid as outliers
from
	#v_dist_mat_mean_diff
where diff_dst > 0
union
select distinct
	ugcid, b_gazetteerid as outliers
from
	#v_dist_mat_mean_diff
where diff_dst > 0	
)
update ugc_gaz
 set is_outlier=1
from
	ugc_gaz
	join
		(select
			a.ugcid
			,a.outliers as gazetteerid
			,min(tmp.diff_dst) as min_dif_dst
		from
			#v_dist_mat_mean_diff tmp
			join (
				select ugcid, outliers from outliers
				except 
				select ugcid, inliers from inliers) as a
				on tmp.ugcid = a.ugcid and tmp.a_gazetteerid = a.outliers
		group by
			a.ugcid, a.outliers
		having 
			min(tmp.diff_dst) > 20000
		) as o
		on ugc_gaz.ugcid=o.ugcid and ugc_gaz.gazetteerid=o.gazetteerid