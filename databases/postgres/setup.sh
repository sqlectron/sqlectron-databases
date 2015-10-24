#!/bin/bash
set -e

log() {
  echo "SETUP: $1"
}

pgExecQuery() {
  gosu postgres psql -c "$1"
}

pgExecScript() {
  gosu postgres psql --dbname "$1" < "$2"
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
  EXISTS=$(pgExecQuery "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")

  if [[ $EXISTS == "1" ]]; then
    log "Database [$DB_NAME] already exists"
  else
    log "Creating database [$DB_NAME]"
    pgExecQuery "CREATE DATABASE \"$DB_NAME\""

    DB_SCHEMA="/docker-entrypoint-initdb.d/schemas/${DB_NAME}.sql"
    if [[ -f $DB_SCHEMA ]]; then
      log "Creating database schema"
      pgExecScript $DB_NAME $DB_SCHEMA
    fi

    log "Created database"
  fi
done

log "Finished databases setup"
