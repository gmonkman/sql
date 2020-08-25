--BULK INSERT MULTIPLE FILES From a Folder 

    --a table to loop thru filenames drop table ALLFILENAMES
		IF OBJECT_ID('dbo.ALLFILENAMES', 'U') IS NOT NULL 
			DROP TABLE dbo.ALLFILENAMES; 

	
    CREATE TABLE ALLFILENAMES(WHICHPATH VARCHAR(255),WHICHFILE varchar(255))

    --some variables
    declare @filename varchar(255),
            @path     varchar(255),
            @sql      varchar(8000),
            @cmd      varchar(1000)


    --get the list of files to process:
    SET @path = 'C:\Users\GRAHAM~1\OneDrive\GISDATA\ons\'													--******CHANGE THIS******
    SET @cmd = 'dir ' + @path + '*.csv /b'																							--******CHANGE THIS******
    INSERT INTO  ALLFILENAMES(WHICHFILE)
    EXEC Master..xp_cmdShell @cmd
    UPDATE ALLFILENAMES SET WHICHPATH = @path where WHICHPATH is null

		
    --cursor loop
    declare c1 cursor for SELECT WHICHPATH,WHICHFILE FROM ALLFILENAMES where WHICHFILE like '%.csv%' --******CHANGE THIS******
    open c1
    fetch next from c1 into @path,@filename
    While @@fetch_status <> -1
      begin
      --bulk insert won't take a variable name, so make a sql and execute it instead:
       set @sql = 'BULK INSERT town FROM ''' + @path + @filename + ''' '								--******CHANGE THIS******
           + '     WITH ( 
                   FIELDTERMINATOR = '','', 
                   ROWTERMINATOR = ''\n'', 
                   FIRSTROW = 2													--******CHANGE THIS RE. HEADERS******
                ) '
    print @sql
    exec (@sql)

      fetch next from c1 into @path,@filename
      end
    close c1
    deallocate c1


    --select * from ALLFILENAMES
    --drop table ALLFILENAMES