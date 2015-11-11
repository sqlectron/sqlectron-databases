#!/bin/bash
set -e

log() {
  echo "SETUP: $1"
}

log "Creating user with no password"
MYSQL_USER_NO_PWD="usernopwd"

mysql -u root -p"${MYSQL_ROOT_PASSWORD}" << EOF
CREATE USER \`$MYSQL_USER_NO_PWD\`@`%`;
GRANT ALL privileges ON \`authentication\`.* TO \`$MYSQL_USER_NO_PWD\`@`%`;
EOF

log "Setuping databases"

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

log "Setuping database [$DB_NAME]"

mysql -u root -p"${MYSQL_ROOT_PASSWORD}" << EOF

CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL privileges ON \`$DB_NAME\`.* TO \`$MYSQL_USER\`@`%` IDENTIFIED BY 'password';
GRANT ALL privileges ON \`$DB_NAME\`.* TO \`$MYSQL_USER_NO_PWD\`@`%`;

EOF

done

log "Finished databases setup"
