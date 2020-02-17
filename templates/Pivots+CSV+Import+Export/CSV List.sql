/*Do an aggregate query on a table, grouping by a 
defined column and concatenate other column results into a
csv list in a seperate column
*/

/*
EXAMPLE


Table tbl
id	data_to_list
a			1
a			2
a			3
b			4
b			5

*/



SELECT --this first select is a cludge, just to get rid of the leading comma in the csv column
	id
	,RIGHT(NameValues, len(NameValues) - 1) as csv
FROM
(
	SELECT 
		id
		,(
						SELECT 
							',' + CAST(data_to_list AS nvarchar(max)) 
						FROM
							tbl 
						WHERE 
							(id = Results.id) 
						FOR XML PATH ('')
						)
						as NameValues
	FROM 
		tbl as Results
	GROUP BY
		id
) as a


/* out 
id	csv
a		1,2,3
b		4,5
*/