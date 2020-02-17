/* This query will take an sql server column which contains csv
data and convert it into a longform list

table1
id	csvcol
----------------
A		a,aa,aaa,aaa
B		b,bb


Variables
=========
alias: column with csv data
gn_featureid: primary key (or other key column)
DataItem, tmp: [Leave as is, in query variable]

Note
====
The out SELECT can be be an INSERT, or other SQL, eg.

....) 
INSERT INTO gn_feature_alias (gn_featureid, gn_feature_alias) select
    gn_featureid,
    DataItem
FROM tmp
ORDER BY gn_featureid
OPTION (maxrecursion 0)
*/

;WITH tmp(gn_featureid, DataItem, alias) AS
(
    SELECT
        gn_featureid,
        LEFT(alias, CHARINDEX(',', alias + ',') - 1),
        STUFF(alias, 1, CHARINDEX(',', alias + ','), '')
    FROM gn_feature
		where isnull(alias, '') <> ''
    UNION all
    SELECT
        gn_featureid,
        LEFT(alias, CHARINDEX(',', alias  + ',') - 1),
        STUFF(alias, 1, CHARINDEX(',', alias + ','), '')
    FROM
			tmp
    WHERE
        alias > ''
)

SELECT
    gn_featureid,
    DataItem
FROM tmp
ORDER BY gn_featureid
OPTION (maxrecursion 0)


