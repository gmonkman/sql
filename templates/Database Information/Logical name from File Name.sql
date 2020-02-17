select 
[name] as dbname,
[filename] as mdf_name,version

from master..sysdatabases
where filename like '%bury%'