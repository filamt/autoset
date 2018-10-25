#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"


echo $DBPASS

/usr/bin/mysql_install_db --user=mysql

systemctl start mariadb


SECURE_MYSQL=$(expect -c "
set timeout 3
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Set root password?\"
send \"y\r\"
expect \"New password:\"
send \"$DBPASS\r\"
expect \"Re-enter new password:\"
send \"$DBPASS\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"





exit 0

