declare 
	@name varchar(100),
	@datepart varchar(100)

set @datepart =  
	cast(datepart(dw,getdate()) as varchar) 

set @name = 'C:\MSSQL\BackUp\Sheffield\p2_sheffield_' + @datepart + '.bak'
BACKUP DATABASE p2_sheffield TO DISK = @name