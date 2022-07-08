#!/bin/bash

# Wait for MariaDB server to be ready
MYSQL_OK="0"
while [ "${MYSQL_OK}" = "0" ]; do
    nc -v -z ${K8S_DB_HOST} ${K8S_DB_PORT}
    if [ "$?" = "0" ]; then MYSQL_OK=1; fi
    sleep 2
done

alembic -c alembic.ini upgrade head 
alembic -c alembic.ini current
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 80
