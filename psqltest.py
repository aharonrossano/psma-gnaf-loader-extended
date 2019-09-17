#!/usr/bin/python2.4
#

# su - postgres
# psql postgres

# ALTER USER postgres PASSWORD 'postgres';

# CREATE DATABASE psma;
# \l
# \c psma;

# CREATE EXTENSION postgis;
# CREATE EXTENSION postgis_topology;


import psycopg2
try:
    conn = psycopg2.connect(dbname="docker", user="docker", password="docker", host="localhost")
except:
    exit(1)

exit(0)