--update gn_feature, setting the column IFCA to be the IFCA name in which the point is found

update 
	gn_feature --points
set 
	gn_feature.IFCA=v_ifca_area_noholes_wgs84.name
from
	gn_feature
	inner join v_gn_feature on v_gn_feature.id=gn_feature.gn_featureid
	inner join v_ifca_area_noholes_wgs84 on v_gn_feature.geog.STIntersects(v_ifca_area_noholes_wgs84.geog) = 1;