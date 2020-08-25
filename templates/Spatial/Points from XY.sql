insert into geograph_geom
	select geograph.gridimage_id, geography::Point(wgs84_lat, wgs84_long, 4326) from geograph
