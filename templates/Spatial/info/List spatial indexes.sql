	--see https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-spatial-indexes/
Select
name
,sys.all_objects.object_id
,tessellation_scheme
,bounding_box_xmin,bounding_box_ymin
,bounding_box_xmax,bounding_box_ymax
,cells_per_object
from 
	sys.spatial_index_tessellations
	inner join sys.all_objects on sys.spatial_index_tessellations.object_id=sys.all_objects.object_id


select top 10 * from sys.all_objects


select * from sys.spatial_indexes

