/* REPLACE <COL> and <TABLE>  Uses Double Quotes*/
SELECT top 1 --this first select is a cludge, just to get rid of the leading comma in the csv column
	'[' + RIGHT(NameValues, len(NameValues) - 1) + ']' as csv
FROM
(
	SELECT 
		(
						SELECT 
							',"' + CAST([<COL>] AS nvarchar(max)) + '"'
						FROM
							[<TABLE>]
						FOR XML PATH ('')
						)
						as NameValues
	FROM 
		[<TABLE>] as Results

) as a

