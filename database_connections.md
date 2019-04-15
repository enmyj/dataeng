# Introduction to Databases

The intended audience of this guide is data analysts/scientists/engineers. The goal is to provide a quick-start guide to using pre-configured databases.

# Database Basics

### What is a database?  
A database is a software application running on a computer. Databases are typically run on servers hosted on internal networks on or the cloud. In most cases, databases are run on specialized hardware designed to handle the computational and memory loads of the specific database software. However, for testing purposes databases can also be run locally on laptops or desktops. 

### What types of databases exist?   
Databases come in two main flavors - Relational and NoSQL.   

Relational databases have been around for a long time and are most commonly used as the back-end for software applications. Relational databases excel at storing structured data and the relationships between the data. Data is retrieved from relational databases using SQL (structured query language) queries/statements. Each database has its own SQL dialect but core SQL is common between all databases. A few popular relational databases include `MySQL`, `Postgres`, `Microsoft SQL Server`, and `Oracle`.  

NoSQL databases are relatively new and there is a wider variety of database types. These databases excel at storing unstructured data such as documents. A few popular NoSQL databases include `mongoDB` and `Hbase`. 

### Why use a database instead of a flat file? 

Databases have tons of benefits, especially for larger data or complicated analyses. One of the primary benefits of databases is the ability to leverage the database server to peform memory intensive or computationally expensive tasks such as joining data together or subsetting data based on criteria. Also, the source data for many  analytical data sources is already stored in a dataabase, so it's often easier to use the data in its source format rather than converting to flat files and then performing analysis.   

One downside to using databases over flat files is the overhead required to maintain the database and ingest data into it. For low-memory or low complexity tasks, a flat file is probably sufficient. 

# Connecting to Databases

The main tools used to connect to databases are:    
   1. GUI (e.g., DBeaver, Microsoft SQL Server Management Studio)
   2. Command Line Tool (e.g., `mysql`, `psql`, `sqlcmd`)
   3. Programming Language (e.g., `python`,`R`)

Database drivers enable users to connect to databases. My rough description of each:
  - ODBC - first database drivers designed to work across database applications. Co-written by a few companies including IBM and Microsoft
  - JDBC - second major database drivers written in Java by Sun (now Oracle)
  - OLE-DB - newest/fastest drivers written by Microsoft. Not yet adopted by many major databases.  

In my experience, ODBC and JDBC are the most commonly seen in documentation. Most times, users don't have to make a choice of protocol. However, [this](https://stackoverflow.com/questions/21795119/odbc-vs-jdbc-performance) answer provides some guidance for how to choose. 


Database connection terms:
   - `Host` - the ip address or server name of the database server
   - `Port` - the major database applications each have a default network port (e.g., Postgres is 5432). It's common to keep this configuration when setting up the database instance
   - `Database` - many database applications support multiple databases running on the same server. For example: a consulting firm might set up a `MySQL` instance with one database per project. These databases share the `host` and `port` of the `MySQL` instance, but project team members will only be able to connect to their specific project database on this instance. The database name should be provided by the database admin. In some cases, database name is not required to initiate a connection. 
   - `User` - username should be provided by database admin
   - `Password` - password should be provided by database admin

Connection Strings:   

Connection strings are the core object the user must configure when establishing a database connection. Connection string formats vary by database manufacturer and driver type. Typically, the best way to determine a connection string format is to consult documentation or search on StackOverflow. Two example connection strings are below:
```
# jdbc connection to Postgres database
jdbc:postgresql://{host}[:{port}]/[{database}]

# sqlalchemy connection to IBM db2 database
db2+ibm_db://{user}:{pw}@{host}:{port}/{dbname}
```

## Connecting using a GUI
--- 

Most (all?) major database manufacturers offer a GUI specific to their database (e.g., `Pgadmin` for Postgres databases). There are also database-agnostic tools such as `DataGrip` (paid) or `DBeaver` (free, open source) which permit connection to most major database applications. The basic steps to establishing a connection are:   

1. Find the "create a new connection" menu and select the appropriate database
2. Download the recommended database driver (if applicable)
3. Enter database information (see above)


Database GUIs are best for the following tasks:   
  1. Running adhoc SQL queries and viewing the results. Can also be used to export query results when result sets are small. 
  2. Protyping queries for a pipeline or analysis
  3. Viewing database/schema/table definitions
  4. Performing database administration tasks

## Connecting using a command line tool
---

Similar to database GUIs, most (all?) major databases offer a command line tool that permits connecting to their database from a shell. Examples include `mysql`, `psql`, and `sqlcmd`. These tools allow the user to either (1) issue queries/statements interactively and (2) run database (SQL) scripts from shell commands/scripts.

The following example will create an interactive session against a postgres database running locally: 

```bash
# password supplied after command is run
psql -h localhost -p 5432 -d TEST -U ian.myjer
```

The following example will run a local sql script against a postgres database running locally:
```bash
psql -h localhost -p 5432 -d TEST -U ian.myjer --file=/path/to/sql_script.sql
```
NOTE: To avoid typing in the password each time this command is run, most database tools allow users to store their passwords in a file and pass that file to the command line tool. [Postgres Example](https://stackoverflow.com/questions/6405127/how-do-i-specify-a-password-to-psql-non-interactively) and [MySQL Example](https://serverfault.com/questions/476228/whats-a-secure-alternative-to-using-a-mysql-password-on-the-command-line). Storing the password as an shell environment variable should be avoided. 

Database command line tools are best for the following tasks:
  1. Running queries interactively when a database GUI is not permitted or not available
  2. Running database (SQL) scripts as part of a shell script or pipeline

## Connecting through Python
---

The best/easiest way to connect to a database from python is using `sqlalchemy`. SQL alchemy can be installed the usual way using `pip` or `conda`. For major databases such as `postgres` or `mysql`, connections can be established without the need to install external packages. [sqlalchemy reference documentation](https://docs.sqlalchemy.org/en/13/core/engines.html)

The `sqlalchemy` package consistes of two universes - ORM and Core. ORM is designed to be used as the backend for python-based web applications and therefore has a different and more complex usage pattern. For most (all?) analytical use cases, the `sqlalchemy` core is the best and easiest to use. 

Note on password security: The practice of securely passing a password to a python script with having it end up in a public `git` repository used to befuddle me - until I was shown [this Rstudio blog](INSERT LINK) on securing credentials. It lists, from most to least secure, the various ways to store passwords in scripts. The equivalent package to the INSERT R PACKAGE is python's `keyring`. 

Passwords can be set securly using the keyring GUI or using:
```python
EXAMPLE
```

Below is a basic database connection example: 

```python
# basic imports
from sqlalchemy import create_engine
from sqlalchemy import text
import keyring
import pandas as pd

# set database connection string
# assumes password has been set using appropriate keyring backend
username = "ian.myjer"
password = keyring.get_password(
    service_name = 'test', 
    username = username)
host = "localhost"
database = "foo"
port = "3306"

conn_str = 'mysql://{username}:{password}@{host}:{port}/{database}'.format(
    username = username,
    password = password,
    host = host,
    port = port,
    database = database)

# create sqlalchemy engine
engine = create_engine(conn_str)

# create a connection and issue a sql query
# storing results in res variable
# NOTE: using the "with" syntax automatically closes the connection
# once the query is complete
query = text('select * from example_table')
with engine.begin() as conn:
    res = conn.execute(query).fetchall()

# Issue a sql statement (insert, update, delete, drop, etc.)
with engine.begin() as conn:
    conn.execute(text('create table test (id int)'))

# get results and store as pandas dataframe
res = pd.from_sql(con = engine, sql = query)

# write pandas dataframe to sql
df.to_sql(
    'table_name', 
    con = engine, 
    schema=None, 
    if_exists='fail', 
    index=False)
```

CONNECTING through python JDBC??

## Connecting through R
---

The Rstudio blog has good documentation for connecting to databases [here](insert link). However, less popular databases are not well covered. Below is a basic example of connecting to a `db2` database using `JDBC`. 

As mentioned in the Rstudio securing credentials [documentation](UPDATE ME), the `config` package can be useful for managing database connections. 

config.yaml
```yaml
default:
  database:
    host: "server_name.domain.com"
    port: "50000"
    username: ian.myjer
    database_name: example
    driver_path: /Users/ian.myjer/drivers/db2jcc.jar
```

dope_script.R
```R
# basic imports
library(DBI)
library(RJDBC)
library(config)
library(NAME OF KEYCHAIN PACKAGE)

# get database configurations from config.yml file
conf <- config::get()

# specify JDBC driver
jcc <- RJDBC::JDBC("com.ibm.db2.jcc.DB2Driver", conf$database$driver_path)

# configure connection
conn <- RJDBC::dbConnect(
  drv = jcc,
  url = paste0("jdbc:db2://", 
    conf$database$host, 
    ":", 
    conf$database$port, 
    "/", 
    conf$database$database_name),
  user = conf$database$username,
  password = KEYCHAIN)

# send query to database and get results back
results <- RJDBC::dbGetQuery(conn, 'select * from sysibm.systables')

# send update (insert, update, drop, delete, etc.)
RJDBC::dbSendUpdate(conn,'create table example.example (id int)')

# write R data.frame to database
RJDBC::dbWriteTable(
  conn = conn,
  name = 'table_name',
  value = cool_r_dataframe,
  row.names = F)

# close connection
RJDBC::dbDisconnect(conn)
```

## Using ODBC
---

FILL ME IN 

## Connecting to Microsoft SQL Server using Kerberos Authentication from a Mac or Linux
---

My experience using Microsoft SQL Server running in a Windows environment is that DBAs usually set up user credentials using Windows (Kerberos) Authentication. As a user on a Windows computer that is connected to this domain, this is pretty straightforward. But, using a Windows computer not connected to the Kerberos domain is a pain in the ass. And using a Mac or Linux computer not connected to the domain is even worse. 

### Windows Computer Not on Domain
FILL ME IN 


### Mac/Linux Computer Not on Domain

I've found the Kerberos documentation to be terrible and internet sources on the subject to be rather sparse. This is the best documentation I've found [link](https://kb.iu.edu/d/aumh#create). Note: Domain must be in ALL CAPS for some reason

```bash
# open stupid ktutil command line thing
ktutil

# add password to keytab (will prompt for password)
addent -password -p ian.myjer@DOMAIN.COM -k 1 -e rc4-hmac

# do it again for some reason?
addent -password -p ian.myjer@DOMAIN.COM -k 1 -e aes256-cts

# save it
wkt ~/ian.myjer.keytab
quit

# to get a new ticket
kinit ian.myjer@DOMAIN.COM -k -t ~/ian.myjer.keytab
```

The Microsoft [documentation](insert link) recommends putting the last command on a `crontab` so that a Kerberos ticket (TGT?) can re-requested prior to expiration. I did some basic testing and verified that nothing happens if you re-request the ticket in the middle of a query.   

The other option is to run the `kinit` command as a subprocess from inside the appropriate script, and then run the database commands. This feels less ideal to me but oerall seems fine. 

Once a ticket has been requested, connections can be established in python/R using the appropriate `odbc` packages

Python
```python
import pyodbc
from sqlalchemy import create_engine
from sqlalchemy import text

conn_str = 'mssql+pyodbc://FILL ME IN'
engine = create_engine(conn_str)
```

R
```R
library(DBI)
library(odbc)

conn <- DBI::dbConnect(
  odbc(), 
  Driver = "ODBC Driver 17 for SQL Server", 
  Server = "server_name@domain.com", 
  Trusted_Connection = "yes", 
  Database = "database_name")
```

