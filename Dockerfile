FROM ubuntu:18.04
MAINTAINER Aharon Rossano <aharon@rossano.co>

RUN apt-get update

## install vim 
RUN apt-get install apt-file -y && apt-file update && apt-get install vim -y

## install python
# RUN ln -s /usr/bin/python3 /usr/bin/python
# this might error?
RUN ln -sf /usr/bin/python3 /usr/bin/python
# RUN ln -sf /usr/bin/python /usr/local/bin/python
RUN apt-get install -y python3-pip
RUN ln -s /usr/bin/pip3 /usr/bin/pip


## configure postgres repository
RUN apt-get install -y wget
RUN apt-get install -y lsb-release
RUN apt-get install -y gnupg2

# for older versions of postgres:
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

## install postgres
RUN apt-get update
RUN apt-get upgrade -y

# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
# avoid postgres asking for tzdata to be configured
ENV TZ=Australia/Melbourne
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y --no-install-recommends postgresql postgresql-contrib postgis
# not sure if this is latest:
RUN apt-get install -y postgresql-11-postgis-2.5-scripts
RUN pip install psycopg2-binary
# is this useful: postgresql-11-pgrouting

# https://support.plesk.com/hc/en-us/articles/115003321434-How-to-enable-remote-access-to-PostgreSQL-server-on-a-Plesk-server-
# RUN sh -c 'echo "listen_addresses = \'*\'" >> /etc/postgresql/11/main/postgresql.conf'
RUN echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf

# RUN sh -c 'echo "host all all 0.0.0.0/0 trust" >> /etc/postgresql/11/main/pg_hba.conf'
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/11/main/pg_hba.conf

## postgres start and start on boot
RUN apt-get install -y systemd
RUN systemctl enable postgresql
RUN service postgresql restart

# https://stackoverflow.com/questions/26598738/how-to-create-user-database-in-script-for-docker-postgres

# FROM library/postgres
# COPY init.sql /docker-entrypoint-initdb.d/

#FROM library/postgres
#ENV POSTGRES_USER docker
#ENV POSTGRES_PASSWORD docker
#ENV POSTGRES_DB docker

USER postgres
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker
RUN service postgresql restart

RUN PGPASSWORD=docker psql -U docker -h localhost -d docker --command "CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;"

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# add extensions
# COPY ./scripts/init.sql /docker-entrypoint-initdb.d
# RUN psql -f ./scripts/init.sql docker

# switch back to root
USER root

# entry point
# CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

# RUN adduser --system --uid 1000 --shell /bin/bash loader
#USER loader

WORKDIR /app
ENV HOME /app

VOLUME ["/data"]
COPY . /app

ENTRYPOINT /bin/bash

# entrypoint shell script that by default starts runserver
# ENTRYPOINT ["/app/docker-entrypoint.sh"]

# CMD ["bash"]
# CMD /bin/bash
# CMD ["loader"]
