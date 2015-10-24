#!/bin/bash
set -e

echo "SETUP: Setuping databases"

DATABASES=(
  "notification"
  "file"
  "content"
  "version"
  "client001"
  "client002"
  "client003"
)

for DB_NAME in "${DATABASES[@]}"; do
EXISTS=`gosu postgres psql user $POSTGRES_USER <<-EOSQL
  SELECT 1 FROM pg_database WHERE datname='$DB_NAME';
EOSQL`

if [[ $EXISTS == "1" ]]; then
  echo "SETUP: Database [$DB_NAME] already exists"
else
  echo "SETUP: Creating database [$DB_NAME]"
  gosu postgres psql user $POSTGRES_USER <<-EOSQL
		CREATE DATABASE "$DB_NAME";
	EOSQL
  echo "SETUP: Created database"
fi
done


echo "SETUP: Finished databases setup"
