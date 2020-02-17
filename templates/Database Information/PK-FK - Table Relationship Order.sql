with cteFK (pktable, fktable) as ( 
       select             
            pktable = s1.name + '.' + o1.name 
       ,    fktable = isnull(s2.name + '.' + o2.name, '')        
       from sys.objects o1       
       left outer join sys.sysforeignkeys fk on o1.object_id = fk.fkeyid        
       left outer join sys.objects o2 on o2.object_id = fk.rkeyid        
    left outer join sys.schemas s1 on o1.schema_id = s1.schema_id
    left outer join sys.schemas s2 on o2.schema_id = s2.schema_id
       where o1.type_desc = 'user_table'       
       and o1.name not in ('dtproperties','sysdiagrams')        
       group by s1.name + '.' + o1.name 
      , isnull(s2.name + '.' + o2.name, '')       
), cteRec (tablename, fkcount) as  ( 
       select tablename = pktable 
       ,    fkcount = 0
       from cteFK    
       
       UNION ALL       
       
    select tablename = pktable 
       , fkcount = 1
       from cteFK  
       cross apply cteRec        
       where cteFK.fktable = cteRec.tablename    
       and cteFK.pktable <> cteRec.tablename
) 
select
 TableName
, InsertOrder = dense_rank() OVER ( ORDER BY max(fkcount) asc )
from (       
       select
              tablename = fktable
       ,      fkcount = 0 
       from cteFK 
       group by fktable    
        
       UNION ALL    
 
       select tablename = tablename, fkcount = sum(ISNULL(fkcount,0))   
       from cteRec      
       group by tablename
     ) x 
where x.tablename <> ''
group by tablename 
order by InsertOrder asc, TableName asc