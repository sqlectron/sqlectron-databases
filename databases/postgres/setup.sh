#!/bin/bash
set -e

log() {
  echo "SETUP: $1"
}

DATABASES=(
  "notification"
  "file"
  "content"
  "version"
  "client001"
  "client002"
  "client003"
  "company"
)

log "Setuping databases"

for DB_NAME in "${DATABASES[@]}"; do
EXISTS=`gosu postgres psql user $POSTGRES_USER <<-EOSQL
  SELECT 1 FROM pg_database WHERE datname='$DB_NAME';
EOSQL`

if [[ $EXISTS == "1" ]]; then
  log "Database [$DB_NAME] already exists"
else
  gosu postgres psql user $POSTGRES_USER <<-EOSQL
		CREATE DATABASE "$DB_NAME";
	EOSQL
  log "Creating database [$DB_NAME]"

  DB_SCHEMA="/docker-entrypoint-initdb.d/schemas/${DB_NAME}.sql"
  if [[ -f $DB_SCHEMA ]]; then
    gosu postgres psql --dbname "$DB_NAME" < $DB_SCHEMA
    log "Creating database schema"
  fi
  log "Created database"
fi
done


echo "SETUP: Finished databases setup"
