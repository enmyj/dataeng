-- create table with partition based on bill paid date
create table imyjer.ptest as (
  select * 
  from imyjer.test
  fetch first 1 rows only
  ) with no data
partition by range (date_col) (
starting from '2018-01-01' ending at '2018-05-01' exclusive
every 1 month
);

-- drop the second partition (2018-03-01 to 2018-04-01)
alter table imyjer.ptest
	detach partition part2 into junk;
drop table junk;

-- re-add the partition
alter table imyjer.ptest
  add partition
  starting '2018-03-01'
  ending '2018-04-01' exclusive;

-- add another partition
alter table imyjer.ptest
  add partition
  starting '2018-05-01'
  ending '2018-06-01' exclusive; 
