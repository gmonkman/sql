SELECT
	<COL>
	,LEN(REPLACE(REPLACE(REPLACE(' '+<COL>,'  ',' '+CHAR(1)) ,CHAR(1)+' ',''),CHAR(1),'')) -  LEN(REPLACE(REPLACE(REPLACE(REPLACE(' '+<COL>,'  ',' '+CHAR(1)) ,CHAR(1)+' ',''),CHAR(1),''),' ','')) [Word Count]
from
	<TABLE>