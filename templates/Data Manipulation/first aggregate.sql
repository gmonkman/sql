/*
this is with two tables,

but priciple is were just choosing the first record from
a slice in an aggregate query rather than max/min etc
*/


select
    ugc.ugcid
	,month_hint_new
from 
	ugc
	join (
		select top 100
			ugcid, hint as month_hint_new,
			row_number() over (order by ugcid, ugc_hintid) -
				rank() over (order by ugcid) as row_num from ugc_hint
			where hint_type='month_hint'
		 ) [first] on [first].ugcid = ugc.ugcid and [first].row_num = 0

