/* INPUT
WARD					CON			LAB			PLAID
Aethwy ED			-0.017	-0.070	0.027
Aethwy ED			0.035		-0.059	0.009
Bro Rhosyr ED	0.050		-0.101	0.016
Bro Rhosyr ED	0.050		-0.101	0.016


OUTPUT
WARD						PARTY		PERC_DIFF
Aethwy ED				Con			0.093
Bro Rhosyr ED		Con			0.050
Bro Rhosyr ED		Lab			-0.101

*/


with t1 as
(
	select
		electoral_wardid as ward
		,con_perc_diff as Con
		,lab_perc_diff as Lab
		,plaid_perc_diff as Plaid
	from
		v_polling_station_count_all v
	where
		not lab_perc_diff is null
)
select
	ward, party, perc_diff
from
	(select * from t1) as r
UNPIVOT
	(
		perc_diff for party in (Con, Lab, Plaid)  
		--perc_diff:name of new data col
		--party:name of new column heading which contains original pivoted col headings 
		--Con|Lab|Plaid:These are original column headings which become the values in col party
	) as unpvt



select top 5 * from v_polling_station_count_all