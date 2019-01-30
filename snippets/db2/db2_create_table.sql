-- create test table in personal schema
-- with auto incrementing primary key
CREATE TABLE IMYJER.TEST (
id integer not null generated always as identity (start with 1, increment by 1)
, foo varchar(40) not null
, bar varchar(40) not null
, baz varchar(40)
, quz int
, primary key (id, foo)
, unique (bar)
);


insert into IMYJER.TEST (foo, bar, baz, quz) values 
('a','a','a',1)
, ('b','b','b',2)
, ('c','c','c',3)
, ('d','d','d',4)
;

