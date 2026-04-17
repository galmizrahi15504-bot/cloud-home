#!/bin/bash
# Creates all the databases needed on first startup

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE nextcloud;
    GRANT ALL PRIVILEGES ON DATABASE nextcloud TO $POSTGRES_USER;
EOSQL

echo "✅ Databases created!"
