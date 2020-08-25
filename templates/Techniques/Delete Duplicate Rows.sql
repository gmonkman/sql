DELETE
FROM MyTable
WHERE ID NOT IN
(
SELECT MAX(ID)
FROM MyTable
GROUP BY DuplicateColumn1, DuplicateColumn2, DuplicateColumn3)