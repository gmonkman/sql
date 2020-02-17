CREATE TABLE tblCourse (
	CourseId INT
	,CourseName VARCHAR(50)
	)

CREATE TABLE tblOffering (
	OfferingId INT
	,CourseId INT
	,LocationId INT
	,AwardId INT
	)

CREATE TABLE tblLocation (
	LocationId INT
	,LocationName VARCHAR(50)
	)

CREATE TABLE tblAward (
	AwardId INT
	,AwardName VARCHAR(50)
	)

INSERT INTO tblCourse
VALUES (
	1
	,'Course A'
	)

INSERT INTO tblCourse
VALUES (
	2
	,'Course B'
	)

INSERT INTO tblOffering
VALUES (
	1
	,1
	,1
	,1
	)

INSERT INTO tblOffering
VALUES (
	2
	,1
	,2
	,1
	)

INSERT INTO tblOffering
VALUES (
	3
	,1
	,3
	,1
	)

INSERT INTO tblOffering
VALUES (
	4
	,1
	,1
	,2
	)

INSERT INTO tblOffering
VALUES (
	5
	,2
	,3
	,1
	)

INSERT INTO tblLocation
VALUES (
	1
	,'Location A'
	)

INSERT INTO tblLocation
VALUES (
	2
	,'Location B'
	)

INSERT INTO tblLocation
VALUES (
	3
	,'Location C'
	)

INSERT INTO tblAward
VALUES (
	1
	,'Award A'
	)

INSERT INTO tblAward
VALUES (
	2
	,'Award B'
	)

DECLARE @COLUMNS VARCHAR(max)
	,@query VARCHAR(1024)
	,@True VARCHAR(6)

SELECT @COLUMNS = COALESCE(@Columns + ',[' + L.LocationName + ']', '[' + L.LocationName + ']')
FROM tblLocation L

SELECT @True = '''True'''

SELECT @QUERY = 'SELECT C.CourseName
                 ,A.AwardName
                 , pvt.*
FROM (SELECT O.OfferingID AS OID
            ,O.AwardID AS AID
            ,O.CourseID AS CID
            ,L.LocationName AS LID
       FROM tblOffering O Inner Join tblLocation L on L.LocationID = O.LocationID) AS S
PIVOT
(
    count(oID) For LID IN (' + @COLUMNS + ')
) As pvt
inner join tblCourse C on C.CourseID = CID
inner join tblAward A on A.AwardID = pvt.AID'

EXEC (@QUERY)
GO


