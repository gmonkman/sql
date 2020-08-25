
if  exists (select * from dbo.sysobjects where id = object_id(N'standard_date') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table standard_date

create table standard_date
(
report_date datetime null,report_date_text varchar(20) null
)
go


DECLARE  
	@date_start datetime,
	@date_end datetime,
	@days int,
	@cnt int

set @cnt=0
set @date_start=cast('2010 Jan 01' as datetime)
set @date_end=cast('2016 Jan 01' as datetime)
set @days = datediff(dd,@date_start,@date_end)

while (@cnt <= @days)
	begin
		insert into standard_date	select dateadd(dd,@cnt,@date_start),''
		set @cnt=@cnt+1
	end

--YYYYMMDD
--http://www.sql-server-helper.com/tips/date-formats.aspx
update standard_date set report_date_text=CONVERT(VARCHAR(10), report_date, 112) 

