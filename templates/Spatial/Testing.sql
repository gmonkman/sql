/* Just some examples of testing geographies for single points */
--select the srid for a geography
SELECT
	geog.STSrid
FROM
	england_wgs84_geog


--Select geoms from a table and test contains
DECLARE @scilly geometry
DECLARE @rocky_hill geometry
DECLARE @men geometry
DECLARE @well geometry

SET @scilly=geometry::STGeomFromText('POLYGON((-6.2768869469665347 49.915640238720449, -6.2791530732690575 49.914476581981226, -6.2829000730159592 49.915867883323791, -6.2857854199107619 49.915401124167794, -6.2833204066869772 49.914322457054496, -6.28229162185811 49.91058083129009, -6.2877440164042095 49.909209090710767, -6.2935742983224063 49.910522857876785, -6.2963793789613751 49.90915887747304, -6.3016942432791359 49.910941331195055, -6.2984961032102129 49.90476063098108, -6.3031330604697642 49.902068534084293, -6.3106343875938649 49.909618823541855, -6.3102470029403408 49.911523105535935, -6.3164065800981044 49.911833540807038, -6.3165932130901155 49.907686889500106, -6.3207196192950894 49.907082965856453, -6.3276839640542768 49.91264537046105, -6.3238562088622556 49.917054103745969, -6.3197408249620493 49.916388813122452, -6.3181986651482829 49.9186241896616, -6.3164496245402368 49.915431666423743, -6.3078692964491276 49.916111272534053, -6.3067146330637165 49.921913791218365, -6.31367721709533 49.926514179595131, -6.3086377871369139 49.929401641893854, -6.3073816531419347 49.932508146959066, -6.299989788509432 49.9340428352766, -6.2980891636513769 49.936183246128309, -6.29039318722307 49.934308881638721, -6.28731541844726 49.932623048490562, -6.2865204397109409 49.929952709740469, -6.281045448505763 49.9295253514093, -6.2801872145591888 49.926137372350574, -6.2765704624564309 49.924651172410968, -6.2746606664553557 49.92040207371398, -6.2768869469665347 49.915640238720449))', 0)
SET @rocky_hill=geometry::STGeomFromText('POINT (-6.2983333333333329 49.923333333333332)', 0)
SET @men = geometry::STGeomFromText('POINT (-6.331666666666667 49.975)',0)
SET @well = geometry::STGeomFromText('POINT (-5.375 50.08)',0)

SELECT @scilly.STContains(@rocky_hill)
SELECT @scilly.STContains(@men)
SELECT @scilly.STContains(@well)




--Select geog from a table and test contains
DECLARE @white geography
DECLARE @rocky_hill geography
DECLARE @men geography
DECLARE @well geography
DECLARE @ashen geography

SET @white=geography::STGeomFromText((select geog.STAsText() FROM v_england_wgs84 where ogr_fid=1), 4326)
SET @rocky_hill=geography::STGeomFromText((select geog.STAsText() as rocky_hill from v_os_gazetteer where name='Rocky Hill'), 4326)
SET @men = geography::STGeomFromText((select geog.STAsText() as rocky_hill from v_os_gazetteer where name='Men-a-vaur'),4326)
SET @well = geography::STGeomFromText((select geog.STAsText() as welloe from v_os_gazetteer where name='Welloe'),4326)
SET @ashen = geography::STGeomFromText((select geog.STAsText() as ashen from v_os_gazetteer where name='Ashengrove'),4326)
SELECT @white.STIntersects(@ashen)
SELECT @white.STIntersects(@rocky_hill)
SELECT @white.STIntersects(@men)
SELECT @white.STIntersects(@well)


