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

The following example will run a local sql script against a postgres database, running locally:
```bash
psql -h localhost -p 5432 -d TEST -U ian.myjer --file=/path/to/sql_script.sql
```
NOTE: To avoid typing in the password each time this command is run, most database tools allow users to store their passwords in a file and pass that file to the command line tool. [Postgres Example](https://stackoverflow.com/questions/6405127/how-do-i-specify-a-password-to-psql-non-interactively) and [MySQL Example](https://serverfault.com/questions/476228/whats-a-secure-alternative-to-using-a-mysql-password-on-the-command-line). Storing the password as an shell environment variable should be avoided. 

Database command line tools are best for the following tasks:
  1. Running queries interactively when a database GUI is not permitted or not available
  2. Running database (SQL) scripts as part of a shell script or pipeline

## Database Password Security in Python/R
---

The practice of securely passing a password to a python/R script without having it end up in a public `git` repository used to befuddle me - until I was shown [this Rstudio blog](https://db.rstudio.com/best-practices/managing-credentials/) on securing credentials. It lists, from most to least secure, the various ways to store passwords in scripts. Both R and python offer the `keyring` package, which works with Mac (Keychain) and Windows (Credential Store/Manager) natively and on Linux by installing the `libsecret` package.

Passwords can be set securly using the appropriate Key Store GUI. 

Or, using `python` interactively:
```python
>>> import keyring
>>> import getpass
>>> keyring.set_password('unique_name_of_password','username',getpass.getpass())
Password: <type password, not stored in command history>
```

Or, using `R` interactively:
```R
library(keyring)
key_set('unique_name_of_password','username')
# type password in little box that pops up
```

Similar code can also be used to set the password from the command line. Be careful about leaking the password into the command history. 

## Connecting through Python
---

The best/easiest way to connect to a database from python is using `sqlalchemy`. sqlalchemy can be installed the usual way using `pip` or `conda`. For major databases such as `postgres` or `mysql`, connections can be established without the need to install external packages. [sqlalchemy reference documentation](https://docs.sqlalchemy.org/en/13/core/engines.html)

The `sqlalchemy` package consistes of two universes - ORM and Core. ORM is designed to be used as the backend for python applications and therefore has a different and more complex usage pattern. For most (all?) analytical use cases, the `sqlalchemy` core is the best and easiest to use. 

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
host = "localhost"
database = "foo"
port = "3306"

# create sqlalchemy engine
engine = create_engine('mysql://{username}:{password}@{host}:{port}/{database}'.format(
    username = username,
    password = keyring.get_password(service_name = 'unique_name_of_password', username = username),
    host = host,
    port = port,
    database = database))

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

Database connections can also be made directly with `odbc` and `jdbc` directly using the `pyodbc` and `jaydebeapi` packages, respectively. 

## Connecting through R
---

The Rstudio blog has great [documentation](https://db.rstudio.com/getting-started/connect-to-database/) for connecting to databases. However, less popular databases are not well covered. Below is a basic example of connecting to a `db2` database using `JDBC`. 

As mentioned in the Rstudio securing credentials [documentation](https://db.rstudio.com/best-practices/managing-credentials/), the `config` package can be useful for managing database connection parameters.

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
library(keyring)

# get database configurations from config.yml file
conf <- config::get()

# specify JDBC driver
jcc <- RJDBC::JDBC("com.ibm.db2.jcc.DB2Driver", conf$database$driver_path)

# configure connection
conn <- RJDBC::dbConnect(
  drv = jcc,
  url = paste0("jdbc:db2://", conf$database$host, ":", conf$database$port, "/", conf$database$database_name),
  user = conf$database$username,
  password = keychain::key_get('unique_name_of_password',conf$database$username))

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

## Configuring ODBC Connections
---

### Windows

Windows has a built-in ODBC driver manager which can be accessed by typing "ODBC Data Sources" into the Windows Start Menu. Note that there is a separate manager for 32-bit and 64-bit drivers and you'll need to match your driver style to the Software type (64-bit R must use 64-bit odbc drivers). Typically, an ODBC data source can be set up by first installing the appropriate drivers and then following the proper menus to set up the connection. The Driver Manager should provide the option to test the connection prior to attempting to run python or R scripts.

### Mac

1. Install the following packages:
```bash
brew update && brew install unixodbc mssql-tools
```

2. Edit (or create) this file: `~/.odbc.ini`
```bash
[DATA_SOURCE_NAME]
Driver=ODBC Driver 17 for SQL Server
Server=<server_name>
Database=<db_name>
Port=1433
```

### Linux
1. Install the following packages:
```bash
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
        && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

apt-get update && ACCEPT_EULA=Y apt-get install -y unixodbc-dev msodbcsql17 mssql-tools
```
2. Edit (or create) the following file: `/etc/odbc.ini`
```bash
[DATA_SOURCE_NAME]
Driver=ODBC Driver 17 for SQL Server
Server=<server_name>
Database=<db_name>
Port=1433
```

`sqlcmd`
```bash
sqlcmd -S -D DSN_NAME -U ian.myjer -P
```

`Python`
```python
import pyodbc
from sqlalchemy import create_engine
from sqlalchemy import text
import keyring

engine = create_engine("mssql+pyodbc://ian.myjer:{pass}@DSN_NAME".format(pass=keyring.get_password('pass_key','ian.myjer')))

with engine.begin() as conn:
    res = conn.execute(text('select @@version')).fetchall()
```

`R`
```R
library(DBI)
library(odbc)
library(keychain)

conn <- DBI::dbConnect(
  odbc(), 
  DSN = 'DSN_NAME',
  user = 'ian.myjer',
  password = keychain::key_get('unique_name_of_password','ian.myjer'))
```


## Connecting to Microsoft SQL Server using Kerberos Authentication from a Mac or Linux
---

My experience using Microsoft SQL Server running in a Windows environment is that DBAs usually set up user credentials using Windows (Kerberos) Authentication. This is generally a pain in the ass but here we are:

### Windows Computer Not on Domain

It seems like the play is to run `python` or `R` using something: `runas /netonly` [link](https://dba.stackexchange.com/questions/66014/connect-to-sql-server-with-windows-authentication-in-a-different-domain). Seems like there should be a better way though...

### Mac/Linux Computer Not on Domain

On Mac, Kerberos is installed by default. On Linux, it can be installed by running: 
```bash 
apt install -y krb5-user
```

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

The Microsoft [documentation](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/using-integrated-authentication?view=sql-server-2017) recommends putting the last command on a `crontab` so that a Kerberos ticket (TGT?) can be re-requested prior to expiration. I did some basic testing and verified that nothing happens if you re-request the ticket in the middle of a query. The other option is to run the `kinit` command as a subprocess from inside the appropriate script, and then run the database commands. This feels less ideal to me but overall seems fine. 

Once a ticket has been requested, connections can be established in python/R using the appropriate `odbc` packages. On Mac/Linux, the DSN Entry would look like: 

Mac DSN: `~/.odbc.ini`.  
Linux DSN: `/etc/odbc.ini`
```
[DSN_NAME]
Driver=ODBC Driver 17 for SQL Server
Server=<server_name>
Database=<db_name>
Port=1433
Trusted_Connection=yes
```

`sqlcmd`
```bash
sqlcmd -E -S -D DSN_NAME
```

`Python`
```python
import pyodbc
from sqlalchemy import create_engine
from sqlalchemy import text
import urllib

# sqlalchemy with DSN (preferred)
engine = create_engine("mssql+pyodbc://DSN_NAME")

# sqlalchemy without DSN
params = urllib.parse.quote_plus("DRIVER={ODBC Driver 17 for SQL Server};SERVER=<SERVER NAME>;Trusted_Connection=yes")
engine = create_engine("mssql+pyodbc:///?odbc_connect={params}".format(params=params))

with engine.begin() as conn:
    res = conn.execute(text('select @@version')).fetchall()

# pyodbc
conn_str = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=<SERVER NAME>Trusted_Connection=yes;'
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()
cursor.fast_executemany = True
```

`R`
```R
library(DBI)
library(odbc)

# With DSN
conn <- DBI::dbConnect(
  odbc(), 
  DSN = 'DSN_NAME')

# Without DSN
conn <- DBI::dbConnect(
  odbc(), 
  Driver = "ODBC Driver 17 for SQL Server", 
  Server = "server_name@domain.com", 
  Trusted_Connection = "yes", 
  Database = "database_name")
```
