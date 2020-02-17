--select dbo.fGenerateSQLSelectWithJoins('package',1)
-- select * from section_template_header
alter function fGenerateSQLSelectWithJoins
(
	@tablename varchar(50),@exclude_guids bit
)
returns varchar(8000)
as
BEGIN

	DECLARE    
		@colname varchar(200),	
		@sql varchar(8000),
		@sep char(1),
		@tbl varchar(200),
		@fktbl varchar(200),
		@datatype varchar(200),
		@lj varchar(8000),
		@s varchar(100),
		@fk_col varchar(100),
		@pkcol varchar(50),
		@pktablecol varchar(50)
		set @sql = 'SELECT '
		set @lj=''
		
		set @tbl=@tablename
		set @pkcol='[' + @tablename + 'id' + ']'
		set @tbl=replace(@tbl,'[','')
		set @tbl=replace(@tbl,']','')
		set @tbl= '[' + @tbl
		set @tbl= @tbl+']'
		
	
	DECLARE action CURSOR FOR 
			select 
				column_name,data_type
			from 
				information_schema.columns
			where	
				table_name=@tablename
			order by ordinal_position


	OPEN action 
	FETCH NEXT FROM action INTO @colname,@datatype
	WHILE @@FETCH_STATUS = 0 

	BEGIN 
		set @colname='[' + @colname + ']' 
		if charindex('unique',@datatype)>0 and @colname<>@pkcol --dont process the pk col, treat it as a standard col
			begin
				if @exclude_guids=1
					set @s=''
				else
					set @s= @tbl + '.' + @colname + ','
					
				if right(@colname,3)='id]' 
					begin
						set @fk_col = left(@colname,len(@colname)-3) + ']'
						set @fktbl=@fk_col
						set @fk_col=  @fk_col + '.' + @fk_col --prepend with fk table name, assuming field is well formed fktablenameid and fktablename 
						
						--exceptions due to naming oddities
						if @fk_col='[PROJECT].[PROJECT]' set @fk_col='[PROJECT].[TITLE]'
						if @fk_col='[USERPROFILE].[USER]' set @fk_col='[USERPROFILE].[USERNAME]'
						if @fk_col='[USERPROFILE].[USERPROFILE]' set @fk_col='[USERPROFILE].[USERNAME]'
						if @fk_col='[CONTRACT_USER].[CONTRACT_USER]' set @fk_col='[USERPROFILE].[USERNAME]'
						if @fk_col='[PROJECT_COMMISSION].[PROJECT_COMMISSION]' set @fk_col='[PROJECT_COMMISSION].[commission_title]'
						if @fk_col='[SUPPLIERPORTFOLIO].[SUPPLIERPORTFOLIO]' set @fk_col='[PORTFOLIO].[PORTFOLIO]'
						if @fk_col='[PROJECT_TEMPLATE].[PROJECT_TEMPLATE]' set @fk_col='[PROJECT_TEMPLATE].[TEMPLATE_NAME]'
						if @fk_col='[SECTION_TEMPLATE_HEADER].[SECTION_TEMPLATE_HEADER]' set @fk_col='[SECTION_TEMPLATE_HEADER].[NAME]'
						if @fk_col='[WORKING_PATTERN].[WORKING_PATTERN]' set @fk_col='[WORKING_PATTERN].[TITLE]'
						
						[WORKING_PATTERN]
						
						if @fktbl='[CONTRACT_USER]' set @fktbl='[USERPROFILE]'
						
						if charindex('_USER',@fktbl)>0 set @fktbl='[USERPROFILE]'
						if charindex('PORTFOLIO',@fktbl)>0 and charindex('PROJECTPORTFOLIO',@fktbl)=0 set @fktbl='[PORTFOLIO]'
						
						
						set @pktablecol=@colname
						if charindex('USERID',@pktablecol)>0 set @pktablecol='[USERID]'
						if charindex('PORTFOLIOID',@pktablecol)>0 and charindex('PROJECTPORTFOLIO',@pktablecol)=0 set @pktablecol='[PORTFOLIOID]'
						--end exceptions
						
						set @lj = @lj + ' left join ' + @fktbl + ' with (nolock) on ' + @tbl + '.' + @colname + '=' + @fktbl + '.' + @pktablecol 
						set @colname = @s + @fk_col + ',' --rebuld col assuming the fk field is named properly	
					end
			end
		else
			set @colname=@tbl + '.' + @colname

		set @sql=@sql + @colname
		set @sql=@sql + ','

	FETCH NEXT 
		FROM 
			action 
		INTO @colname,@datatype

	End 

	set @sql=ltrim(rtrim(@sql))
	set @sql=replace(@sql,',,',',')
	if right(@sql,1)=',' set @sql=left(@sql,len(@sql)-1)
	set @sql=@sql + ' FROM ' + @tbl + @lj


	Close action
	DEALLOCATE action

--	print @sql

	return @sql
END

