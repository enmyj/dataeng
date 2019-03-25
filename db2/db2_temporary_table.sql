-- create temporary table based on existing table
-- with index on some columns
declare global temporary table temp_test as (
select *
from imyjer.test) 
definition only
on commit preserve rows;

insert into SESSION.temp_test
select *
from imyjer.test;

create index session.idx
  on session.temp_test(foo);

select * from SESSION.temp_test;
