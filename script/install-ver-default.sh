#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"


if [ $MARIADB = "0" ]; then
    yum_install httpd httpd-devel mysql-server mysql php php-devel php-pear php-mysql php-mbstring php-gd
else
	cmd_once "scripts/mariadb-repo-install.sh"
	cmd_once "scripts/mariadb-install.sh
    yum_install httpd httpd-devel php php-devel php-pear php-mbstring php-gd
fi



 