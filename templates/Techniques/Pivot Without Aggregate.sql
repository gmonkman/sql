select 
	SUPPLIER,[1] as Trade,[2] as Trade2
from
(
	select 
		SUPPLIER,SupplierTrade,ROW_NUMBER() over (partition by supplier order by supplier) as RowNum
	from
		v_supplier_trade
) a 
pivot(max(suppliertrade) FOR RowNum in ([1],[2])) as pvt

--Or
--http://stackoverflow.com/questions/14618316/how-to-create-a-pivot-query-in-sql-server-without-aggregate-function
SELECT *
FROM
(
SELECT [Period], [Account], [Value]
FROM TableName
) AS source
PIVOT
(
    MAX([Value])
    FOR [Period] IN ([2000], [2001], [2002])
) as pvt



--FROM STACKOVERFLOW
--http://stackoverflow.com/questions/10404348/sql-server-dynamic-pivot-query/10404455#10404455

DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.category) 
            FROM temp c
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT date, ' + @cols + ' from 
            (
                select date
                    , amount
                    , category
                from temp
           ) x
            pivot 
            (
                 max(amount)
                for category in (' + @cols + ')
            ) p '


execute(@query)

drop table temp