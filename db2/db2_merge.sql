-- create two test tables and merge them together
-- based on some criteria

drop table imyjer.test;
drop table imyjer.test2;

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

CREATE TABLE IMYJER.test2 (
id integer not null generated always as identity (start with 1, increment by 1)
, foo char(40) not null
, bar char(40)
, baz char(40)
, quz int
, primary key (id, foo))
;

insert into IMYJER.test2 (foo, bar, baz, quz) values 
('a','a','a',1)
, ('b','b','b',102)
, ('w','w','w',103)
, ('v','v','v',104)
;

merge into IMYJER.TEST as a
using imyjer.test2 as b
    on a.foo = b.foo
when matched then 
    update set quz = b.quz
when not matched then 
    insert (foo, bar, baz, quz) 
    values (b.foo, b.bar, b.baz, b.quz)
; 

select * from IMYJER.test;
