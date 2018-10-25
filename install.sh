#!/usr/bin/env bash

#181010현재


ROOT_DIR=$( cd "$( dirname "$0" )" && pwd )

source "${ROOT_DIR}/includes/function.sh"

 
#init
cmd_once "script/init.sh"

# Disable SELinux
cmd_once "script/selinux-disable.sh"

#remi-repo 설치
cmd_once "script/remi-repo-install.sh"


#if [ $INSTALL_VER = "1" ]; then
#  cmd_once "script/install-ver-default.sh"
#fi



if [ $MARIADB = "0" ]; then
    yum_install httpd httpd-devel mysql-server mysql php php-devel php-pear php-mysql php-mbstring php-gd
	#echo "install apm default"
else
	cmd_once "scripts/mariadb-repo-install.sh"
	cmd_once "scripts/mariadb-install.sh"
    yum_install httpd httpd-devel php php-devel php-pear php-mbstring php-gd
	#echo "install apm(mariadb)"
fi

