use mmo
go
--species pivot to read in mmo module

/*
create view v_species_pivot as
with cte  (rowid, speciesid, species_aliasid)
as (
	select ROW_NUMBER() OVER ( PARTITION BY speciesid ORDER BY speciesid, species_aliasid) as rowid,
	speciesid, species_aliasid
	from
		v_species_all
		) 
		select * from cte

	sp_configure 'show advanced options', 1;  
RECONFIGURE;
GO 
sp_configure 'Ad Hoc Distributed Queries', 1;  
RECONFIGURE;  
GO  
*/



alter procedure prc_species_pivot as


select into species_pivot exec prc_species_pivot

DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(speciesid) 
            FROM v_species_for_pivot
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT  rowid, ' + @cols + ' from 
            (
                select rowid, speciesid, species_aliasid
                from v_species_for_pivot
           ) as x
            pivot 
            (
                 max(species_aliasid)
                for speciesid in (' + @cols + ') ) as p'
execute(@query)

select speciesid, species_aliasid from v_species_all