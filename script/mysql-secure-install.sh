#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"
<<<<<<< HEAD
 
=======

>>>>>>> 5cdb0b6899e7a9f2d2a7606a60d0e29d9c1cafc6

echo $DBPASS

/usr/bin/mysql_install_db --user=mysql



#부팅시 실행되도록 설정
if [ $OS = "centos7" ]; then
	systemctl start mariadb
else
	service mysql start
fi



<<<<<<< HEAD
=======

>>>>>>> 5cdb0b6899e7a9f2d2a7606a60d0e29d9c1cafc6
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

