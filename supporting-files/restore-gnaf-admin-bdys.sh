#!/usr/bin/env bash

psql -d docker -p 5432 -U docker -c "CREATE EXTENSION IF NOT EXISTS postgis;"

/Applications/Postgres.app/Contents/Versions/11/bin/pg_restore -Fc -d docker -p 5432 -U docker /data/gnaf-201908.dmp
/Applications/Postgres.app/Contents/Versions/11/bin/pg_restore -Fc -d docker -p 5432 -U docker /data/admin-bdys-201908.dmp
