### Config Files and Packages ##
# Loosely based on these instructions:
# https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Mac-OSX

# brew update
# brew install unixodbc
# brew install freetds --with-unixodbc

## append the following to 
# /usr/var/etc/freetds.config (without the comments)
# [MYMSSQL]
# 	host = host.com
# 	port = 1433
# 	tds version = 7.2
# 	database=cool_database_name

## append the following to
# $HOME/.odbc.ini (without the comments)
# [MSSQL_DSN]
# Driver=FreeTDS
# ServerName=MYMSSQL

## append the following to 
# /usr/var/etc/odbcinst.ini (without the comments)
# [FreeTDS]
# Driver = /usr/local/lib/libtdsodbc.so
# Setup = /usr/local/lib/libtdsodbc.so
# FileUsage = 1

## Python Connections to cool_database_name DB
#%% Import Libs
from sqlalchemy import create_engine
from sqlalchemy import text
import pymssql
from string import Template
import pyodbc

#%% pymssql vanilla
conn = pymssql.connect(server='host.com',
                user='DOMAIN\\ian.myjer',
                password='*******',
                database='cool_database_name')
cursor = conn.cursor()

cursor.execute('select top 20 * from TABLE')
row = cursor.fetchone()
print(row)

#%% pymssql SQL Alchemy 
conn_str = 'mssql+pymssql://DOMAIN\\ian.myjer:*******@MYMSSQL/?charset=utf8'
engine = create_engine(conn_str)
query = text('select top 20 * from TABLE')
with engine.begin() as conn:
    conn.execute(text(query)).fetchall()

#%% PYODBC Vanilla
params = {'server':'host.com',
          'port':'1433',
          'database':'cool_database_name',
          'user': 'DOMAIN\\ian.myjer',
          'password': '*******',
          'version':'7.2'}

t = Template('Driver=FreeTDS;SERVER=${server};PORT=${port};'
             'DATABASE=${database};UID=${user};PWD=${password};'
             'TDS_VERSION=${version}')

sql = t.substitute(params)
print('SQL query:\n{0}\n'.format(sql))

conn = pyodbc.connect(sql)
cursor = conn.cursor()

sql = 'select top 20 * from TABLE'
cursor.execute(sql)
rows = cursor.fetchall()
if rows is not None:
    for row in rows:
        print(row)

#%% PYODBC SQL Alchemy
conn_str = 'mssql+pyodbc://DOMAIN\\ian.myjer:*******@MSSQL_DSN'
engine = create_engine(conn_str)
query = text('select top 20 * from TABLE')
with engine.begin() as conn:
    conn.execute(text(query)).fetchall()

# these also work but not recommended by SQL Alchemy
# conn_str = 'mssql+pyodbc://DOMAIN\\ian.myjer:*******@host.com:1433/cool_database_name?driver=/usr/local/lib/libtdsodbc.so'
# conn_str = 'mssql+pyodbc://DOMAIN\\ian.myjer:*******@host.com:1433/cool_database_name?driver=FreeTDS'
