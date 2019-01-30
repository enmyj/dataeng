-- a good reference
-- https://www.ibm.com/developerworks/data/library/techarticle/dm-0711zubiri/index.html

-- create global variable with default value of a string
create variable schema.var varchar(42) default 'a';

-- create global variable with default value from a subquery
create variable schema.var varchar(42) 
default ((select foo from imyjer.test where foo = 'a'));

-- create variable and set value (value only remains during query)
create variable schema.var varchar(42) default 'a';
set schema.var = 'b';

-- access variable from within query
select * 
from imyjer.test t 
where t.foo = schema.var;

-- view contents of variable
values schema.var;

-- drop variable
drop variable schema.var;

-- view all variables in a given schema
select * from sysibm.sysvariables where varschema = 'SCHEMA';

/* 
Kind of jank way to create a variable using correlated subquery
*/
with v (var) as (values('a'))
select *
from imyjer.test as t, v
where t.foo = v.var;

