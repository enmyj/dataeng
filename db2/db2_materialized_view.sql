-- Create a materialized query table (MQT) with immediate refresh, managed by the system
-- Whenever one of the upstream tables are updated
-- the system will automatically update the MQT
create table mqt_ri as (
  select * 
  from imyjer.test)
data initially deferred refresh immediate
maintained by system;

-- Due to the "Data Initially Deferred" clause (which seems to be a requirement to define an MQT)
-- the table will not have any data in it until it is filled with data as follows:
refresh table mqt_ri;

-- create MQT with deferred refresh, managed by system
-- Whenever one of the upstream tables are updated
-- the user must refresh the table manually to update the MQT
create table mqt_rd as (
  select * 
  from imyjer.test)
data initially deferred refresh deferred
maintained by system;
refresh table mqt_rd;

-- prove it works
insert into IMYJER.TEST (foo, bar, baz, quz) values
('q','q','q',10);
select * from imyjer.mqt_ri; -- should have new rows in it automatically
select * from imyjer.mqt_rd; -- should not have new rows in it

-- MQTs should now be the same
refresh table imyjer.mqt_rd;
select * from imyjer.mqt_ri;
select * from imyjer.mqt_rd;

/*
NOTE: It appears that if you drop the upstream table in a system maintained MQT, 
it also drops the MQT
*/
