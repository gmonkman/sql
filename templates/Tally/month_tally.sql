--drop table tally_monthh
create table tally_monthh
(
	nr int not null
	,abbr varchar(10) not null
	,mth varchar(10) not null
	,season varchar(10) not null
)

insert into tally_month select '1','jan','january','winter';
insert into tally_month select '2','feb','february','winter';
insert into tally_month select '3','mar','march','spring';
insert into tally_month select '4','apr','april','spring';
insert into tally_month select '5','may','may','spring';
insert into tally_month select '6','jun','june','summer';
insert into tally_month select '7','jul','july','summer';
insert into tally_month select '8','aug','august','summer';
insert into tally_month select '9','sep','september','autumn';
insert into tally_month select '10','oct','october','autumn';
insert into tally_month select '11','nov','november','autumn';
insert into tally_month select '12','dec','december','winter';
