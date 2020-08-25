use p2_rbkc
go


select * from workitem
select * from elementgroup

select * from workitem

insert into workitem
	select
		newid(),subelementid,'FIX_' + upper(left(subelement,3)),'Repair',rand()*10,'nr','system',getdate(),null,null,'',12,0
	from subelement

insert into workitem
	select
		newid(),subelementid,'REP_' + upper(left(subelement,3)),'Replace',rand()*100,'nr','system',getdate(),null,null,'',12,0
	from subelement




DECLARE  
	@id uniqueidentifier,  
	@val float,	
	@desc nvarchar (100)

DECLARE action CURSOR FOR 
	SELECT
		workitemid,description,rate 
	FROM 
		workitem 

OPEN action 
FETCH NEXT FROM action INTO @id,@desc,@val
WHILE @@FETCH_STATUS = 0 

BEGIN 
	if @desc='Repair'
		set @val=rand()*10+1
	else
		set @val=rand()*100+5

	update workitem set rate=@val	where workitemid=@id
 

FETCH NEXT 
	FROM 
		action 
	INTO @id,@desc,@val

End 

Close action
DEALLOCATE action

select * from workitem
