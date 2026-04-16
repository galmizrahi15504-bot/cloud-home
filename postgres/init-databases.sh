#!/bin/bash
# ============================================================
# 🐘 PostgreSQL — Initialize Multiple Databases
# ============================================================
# This runs automatically on first start.
# Creates separate databases for each service.
# ============================================================

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Nextcloud database
    CREATE DATABASE nextcloud;
    GRANT ALL PRIVILEGES ON DATABASE nextcloud TO $POSTGRES_USER;

    -- Gitea database
    CREATE DATABASE gitea;
    GRANT ALL PRIVILEGES ON DATABASE gitea TO $POSTGRES_USER;

    -- n8n database
    CREATE DATABASE n8n;
    GRANT ALL PRIVILEGES ON DATABASE n8n TO $POSTGRES_USER;

    -- Authelia database (if switching from SQLite later)
    CREATE DATABASE authelia;
    GRANT ALL PRIVILEGES ON DATABASE authelia TO $POSTGRES_USER;
EOSQL

echo "✅ All databases created successfully!"
