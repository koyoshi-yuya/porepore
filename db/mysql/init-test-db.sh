#!/bin/bash
set -euo pipefail

# Restrict identifiers before inserting them into SQL.
for identifier in "$MYSQL_DATABASE" "$MYSQL_TEST_DATABASE" "$MYSQL_USER"; do
  if [[ ! "$identifier" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "MySQL database and user names must contain only letters, numbers or underscores." >&2
    exit 1
  fi
done

if [[ "$MYSQL_DATABASE" == "$MYSQL_TEST_DATABASE" ]]; then
  echo "Development and test databases must have different names." >&2
  exit 1
fi

MYSQL_PWD="$MYSQL_ROOT_PASSWORD" mysql --user=root <<SQL
CREATE DATABASE IF NOT EXISTS \`$MYSQL_TEST_DATABASE\` CHARACTER SET utf8mb4;
GRANT ALL PRIVILEGES ON \`$MYSQL_TEST_DATABASE\`.* TO '$MYSQL_USER'@'%';
-- Rails creates suffixed test databases when running tests in parallel.
GRANT ALL PRIVILEGES ON \`${MYSQL_TEST_DATABASE}\\_%\`.* TO '$MYSQL_USER'@'%';
SQL
