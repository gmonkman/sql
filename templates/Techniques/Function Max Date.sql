select dbo.fDateGetMax('1901 Feb 01',
'1901 Feb 01',
'1905 Feb 05',
'/*1',
null
)

alter FUNCTION fDateGetMax (
	@dt1 varchar(20), @dt2 as varchar(20), @dt3 as varchar(20), @dt4 as varchar(20), @dt5 as varchar(20)
)
RETURNS datetime
AS

BEGIN
	declare 
		@default_date datetime,
		@ret datetime,
		@ddt1 datetime, 
		@ddt2 datetime, 
		@ddt3 datetime, 
		@ddt4 datetime, 
		@ddt5 datetime

	set @default_date='1901 Feb 01'
	set @ret=@default_date
	
	--fix some crap data
	set @dt1=replace(@dt1,'\','/')
	set @dt1=replace(@dt1,'*','/')
	set @dt2=replace(@dt2,'\','/')
	set @dt2=replace(@dt2,'*','/')
	set @dt3=replace(@dt3,'\','/')
	set @dt3=replace(@dt3,'*','/')
	set @dt4=replace(@dt4,'\','/')
	set @dt4=replace(@dt4,'*','/')
	set @dt5=replace(@dt5,'\','/')
	set @dt5=replace(@dt5,'*','/')
	
	if isdate(@dt1)=1 set @ddt1=cast(@dt1 as datetime) else set @ddt1=@default_date
	if isdate(@dt2)=1 set @ddt2=cast(@dt2 as datetime) else set @ddt2=@default_date
	if isdate(@dt3)=1 set @ddt3=cast(@dt3 as datetime) else set @ddt3=@default_date
	if isdate(@dt4)=1 set @ddt4=cast(@dt4 as datetime) else set @ddt4=@default_date
	if isdate(@dt5)=1 set @ddt5=cast(@dt5 as datetime) else set @ddt5=@default_date
	
	set @ret=(
		select max(d)
		from
			(
				select @ddt1 as d
				union
				select @ddt2 as d
				union
				select @ddt3 as d
				union
				select @ddt4 as d
				union
				select @ddt5 as d
			) y
		)
	
	RETURN(@ret)
END

