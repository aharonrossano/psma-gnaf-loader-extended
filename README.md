# PSMA GNAF Ubuntu 18 Postgres 11 docker loader

Working with minus34's gnaf-loader, using his python loading script: https://github.com/minus34/gnaf-loader
minus34 offers multiple solutions for loading the data: python script, docker build and data dumps. 
You can find further description in his readme.

Unfortunately I wasn't able to get the docker builder to work, which uses Postgres 9.6.

I recreated the Dockerfile and docker-compose. 
Using Ubuntu 18 and latest Postgres 11 with Postgis 2.5.

## Changes
- `Dockerfile` and `docker-compose.yml`
- `AUG19_GNAF_PipeSeparatedValue/G-NAF/Extras/GNAF_View/GNAF_TableCreation_Scripts/create_tables_sqlserver.sql` from `datetime` to `TIMESTAMP`.

# Build
I put downloads straight into data folder uncompressed:
`AUG19_GNAF_PipeSeparatedValue` http://data.gov.au/dataset/geocoded-national-address-file-g-naf
`AUG19_AdminBounds_ESRIShapefileorDBFfile` http://data.gov.au/dataset/psma-administrative-boundaries

build or start the machine: `docker-compose up`
rebuild: `docker-compose up --build --force-recreate`

start / restart postgres: `service postgresql restart`  

enter bash:
```
docker ps
docker exec -t -i 0f2a05d954a6 /bin/bash
```

help on commands: `python load-gnaf.py -h`

import data:
`python3 load-gnaf.py --gnaf-tables-path="/data/AUG19_GNAF_PipeSeparatedValue/" --admin-bdys-path="/data/AUG19_AdminBounds_ESRIShapefileorDBFfile/" --pghost="localhost" --pgport="5432" --pgdb="docker" --pguser="docker" --pgpassword="docker"`

pgadmin client to login: https://www.pgadmin.org/download/
u: docker
p: docker
port: 5432
host: localhost

# cleanup
delete image
```
docker system prune -a
```

# Debug
Test postgres connection: `psql -U docker -h localhost` and then `\q` to quit.
Python: `python psqltest.py && echo 'OK' || echo 'FAIL'`. Echos OK or FAIL into CLI.

# Extras
Documentation on creating an ubuntu docker instance for postgres: https://docs.docker.com/engine/examples/postgresql_service/

# Improvements
- Fix version for Postgres in the Dockerfile to 11.5. Version information: "PostgreSQL 11.5 (Ubuntu 11.5-1.pgdg18.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0, 64-bit"
- Fix version for PostGIS to 2.5.2. Version information: "POSTGIS="2.5.2 r17328" [EXTENSION] PGSQL="110" GEOS="3.6.2-CAPI-1.10.2 4d2925d6" PROJ="Rel. 4.9.3, 15 August 2016" GDAL="GDAL 2.2.3, released 2017/11/20" LIBXML="2.9.4" LIBJSON="0.12.1" LIBPROTOBUF="1.2.1" TOPOLOGY RASTER"
- Tidy Dockerfile and docker-compose.yml files.
- Python3 link to python might error in Dockerfile: `ln -sf /usr/bin/python3 /usr/bin/python `

# Notes
Big thanks to Minus34 for putting this together and sharing. 