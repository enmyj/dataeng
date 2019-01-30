-- create test table and fill with junk data
drop table imyjer.test;
CREATE TABLE IMYJER.TEST (
id integer not null generated always as identity (start with 1, increment by 1)
, foo char(40) not null
, bar char(40)
, baz char(40)
, quz int
, primary key (id, foo))
;

insert into IMYJER.TEST (foo, bar, baz, quz) values 
('a','a','a',1)
, ('b','b','b',2)
, ('c','c','c',3)
, ('d','d','d',4)
;

-- create audit table specific to test table
drop table imyjer.test_audit;
CREATE TABLE IMYJER.test_audit (
test_id integer not null
, foo char(40) not null
, bar char(40)
, baz char(40)
, quz int
, action_type varchar(10)
, updated_at timestamp not null with default current timestamp
;

/* TRIGGER for DELETE Statements*/

-- create trigger to insert deleted row from imyjer.test into imyjer.test_audit
drop trigger imyjer.test_delete_trigger;
create trigger IMYJER.test_delete_trigger
after delete on imyjer.test
referencing old as T
for each row
insert into imyjer.test_audit (test_id, foo, bar, baz, quz, action_type) 
values (T.id, T.foo, T.bar, T.baz, T.quz, 'DELETE'); 

-- demonstrate trigger by deleting a row from the test table
delete from imyjer.test where foo = 'a';

-- prove it worked
select * from imyjer.test_audit;

/* Trigger for UPDATE Statements */
  
-- create update trigger
drop trigger imyjer.test_update_trigger;
create trigger IMYJER.test_update_trigger
after update on imyjer.test
referencing old as T
for each row
insert into imyjer.test_audit (test_id, foo, bar, baz, quz, action_type) 
values (T.id, T.foo, T.bar, T.baz, T.quz, 'UPDATE'); 

-- perform a random update
update imyjer.test 
set bar = 'triggerrrrrrrrrr'
where foo = 'b';

-- prove it worked
select * from imyjer.test_audit;
