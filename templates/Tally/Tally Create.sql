--=============================================================================
--      Setup
--=============================================================================
    USE <MYDATABASE>     --DB that everyone has where we can cause no harm
    SET NOCOUNT ON --Supress the auto-display of rowcounts for appearance/speed
DECLARE @StartTime DATETIME    --Timer to measure total duration
    SET @StartTime = GETDATE() --Start the timer
--=============================================================================
--      Create and populate a tally table
--=============================================================================
--===== Conditionally drop and create the table/Primary Key
     IF OBJECT_ID('dbo.tally') IS NOT NULL 
        DROP TABLE dbo.tally
 CREATE TABLE dbo.tally 
        (N INT, 
         CONSTRAINT PK_tally_N PRIMARY KEY CLUSTERED (N))
--===== Create and preset a loop counter
DECLARE @Counter INT
    SET @Counter = 1
--===== Populate the table using the loop and couner
  WHILE @Counter <= 11000
  BEGIN
         INSERT INTO dbo.tally
                (N)
         VALUES (@Counter)
            SET @Counter = @Counter + 1


    END
--===== Display the total duration
 SELECT STR(DATEDIFF(ms,@StartTime,GETDATE())) + ' Milliseconds duration'
