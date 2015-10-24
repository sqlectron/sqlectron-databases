#!/bin/bash
set -e

echo "******SETUPING DATABASES******"

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

echo "******CREATING DATABASE [$DB_NAME]******"
if [[ $EXISTS == "1" ]]; then
  echo "******DATABASE [$DB_NAME] ALREADY EXISTS******"
else
  gosu postgres psql user $POSTGRES_USER <<-EOSQL
		CREATE DATABASE "$DB_NAME";
	EOSQL
  echo "******CREATED DATABASE [$DB_NAME]******"
fi
done


echo "******CREATED ALL DATABASES******"
