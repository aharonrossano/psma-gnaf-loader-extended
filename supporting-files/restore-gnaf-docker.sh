#!/usr/bin/env bash

# docker ps
# docker exec -t -i 0f2a05d954a6 /bin/bash

psql -d docker -p 5432 -U docker -c "CREATE EXTENSION IF NOT EXISTS postgis;"

pg_restore -Fc -d docker -p 5432 -U docker /data/gnaf-201908.dmp
pg_restore -Fc -d docker -p 5432 -U docker /data/admin-bdys-201908.dmp
 