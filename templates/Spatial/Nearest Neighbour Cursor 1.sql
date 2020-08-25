DECLARE @ROW_TOTAL INT = (select count(*) from v_gn_feature)
DECLARE @I int = 1
DECLARE @BATCH_SZ INT = @ROW_TOTAL  / 20

DECLARE @GAZ_PT geography
DECLARE @GAZ_ID int

DECLARE @DIST float
DECLARE @NEAREST_ID int
DECLARE @SQL varchar(max)


--open the cursor
DECLARE cur CURSOR FOR
	SELECT top 10
		v_gn_feature.id
		,v_gn_feature.geog
		--,v_gn_feature.coast_dist_m
		--,v_gn_feature.nn_coastline_wgs84_ogr_fid
	FROM
		v_gn_feature
	ORDER BY
		v_gn_feature.id
	

OPEN cur FETCH NEXT FROM cur into @GAZ_ID, @GAZ_PT

WHILE @@FETCH_STATUS = 0
BEGIN
		SET @NEAREST_ID = NULL --if the select statement returns no rows then the variables are not reassigned
		SET @DIST = NULL

		SELECT TOP 1
			@NEAREST_ID = v_coastline_wgs84.ogr_fid
			,@DIST = v_coastline_wgs84.geog.STDistance(@GAZ_PT)
		FROM
			v_coastline_wgs84
		WHERE
			v_coastline_wgs84.geog.STDistance(@GAZ_PT) < 5000  --i.e. within 5 kilometers of the coast
		ORDER BY
			v_coastline_wgs84.geog.STDistance(@GAZ_PT)
		
		if @NEAREST_ID is null
			BEGIN
				SET @SQL = '' +
				' UPDATE gn_feature SET gn_feature.coast_dist_m = NULL, gn_feature.nn_coastline_wgs84_ogr_fid = NULL' +
				' WHERE gn_feature.gn_featureid=' + cast(@GAZ_ID as varchar)
			END
		else
			BEGIN
				SET @SQL = '' +
				' UPDATE gn_feature SET gn_feature.coast_dist_m=' + cast(@DIST as varchar) + ',gn_feature.nn_coastline_wgs84_ogr_fid=' + cast(@NEAREST_ID as varchar) +
				' WHERE gn_feature.gn_featureid=' + cast(@GAZ_ID as varchar)
			END

	print(@SQL)
	--execute(@SQL)
	SET @I = @I + 1

	FETCH NEXT FROM cur INTO @GAZ_ID, @GAZ_PT

	IF @I % @BATCH_SZ = 0
		select cast(cast(@I * 100 / @ROW_TOTAL as int) as varchar) as percent_complete
END

CLOSE cur
DEALLOCATE cur