SELECT
	[name] as ifca
FROM
	v_ifca_area_noholes_wgs84 
where 
	geography::Point(51, 0.1, 4326).STIntersects(v_ifca_area_noholes_wgs84.geog) = 1;


	select * from v_ifca_area_noholes_wgs84
