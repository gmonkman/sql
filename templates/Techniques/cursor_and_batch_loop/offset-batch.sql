DECLARE @BATCH_SZ INT = 100
DECLARE @OFFSET INT = 0 --Kind of sets the row at @OFFSET then retrieves @BATCH_SIZE rows AFTER offset
DECLARE @ROW_TOTAL INT = (select count(*) from v_gn_feature)


WHILE (@OFFSET <= @ROW_TOTAL - 1)
	BEGIN
			select cast(cast(@OFFSET * 100 / @ROW_TOTAL as int) as varchar) as percent_complete
			--CTE Expression
			;WITH nearest AS
			(
				SELECT 
					ROW_NUMBER() OVER (PARTITION BY v_gn_feature.id ORDER BY v_gn_feature.geog.STDistance(v_coastline_wgs84.Geog) ) as NeighborRank,
					v_gn_feature.id,
					v_gn_feature.name,
					v_coastline_wgs84.ogr_fid as nearest_neighbour_ogr_fid,
					v_gn_feature.geog.STDistance(v_coastline_wgs84.geog) as dist
				FROM
					v_gn_feature
					CROSS JOIN v_coastline_wgs84
				ORDER BY
					v_gn_feature.id OFFSET @OFFSET ROWS FETCH NEXT @BATCH_SZ ROWS ONLY
			)


			UPDATE 
				gn_feature
			SET	
				gn_feature.nn_coastline_wgs84_ogr_fid=nearest.nearest_neighbour_ogr_fid,
				gn_feature.coast_dist_m=dist
			FROM
				gn_feature inner join nearest on nearest.id = gn_feature.gn_featureid
			WHERE
				[NeighborRank] = 1

			--View intermediate results
			--select * from v_gn_feature

			set @OFFSET = @OFFSET + @BATCH_SZ
	END

--select * from v_gn_feature