use gazetteer
go

/*
select  a.ogr_fid, min(a.geom.STDistance(p.geom))

from AddressPoints a, Pipeline p
group by a.ogr_fid

*/

--select top 10 * from os_gazetteer

select top 1
	v_gn_feature.geog.STDistance(coastline_wgs84_geog.geog)
from 
	 v_gn_feature, coastline_wgs84_geog
where
	v_gn_feature.geog.STDistance(coastline_wgs84_geog.geog) is not null
order by
	v_gn_feature.geog.STDistance(coastline_wgs84_geog.geog)
	
	



