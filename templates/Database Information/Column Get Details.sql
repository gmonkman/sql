select column_name, data_type, character_maximum_length from information_schema.columns
where table_name = 'userprofile'
and column_name='username'
