#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"

#http 설치
yum_install httpd httpd-devel


#database 설치(centos7은 기본으로 mariadb 5.4버전 설치됨)
#mariadb 최신버전 체크시에는 10.3으로 설치됨 (181025)

if [ $OS = "centos7" ]; then
	if [ $MARIADB = "0" ]; then
			yum_install mariadb mariadb-server
	else
			cmd_once "script/mariadb-repo-install.sh"
			cmd_once "script/mariadb-install.sh"
	fi
else
	if [ $MARIADB = "0" ]; then
		yum_install mysql-server mysql
	else
		cmd_once "script/mariadb-repo-install.sh"
		cmd_once "script/mariadb-install.sh"
	fi
fi


#php 설치
if [ PHP_VERSION = "0" ]; then
	yum_install php php-devel php-pear php-mysql php-mbstring php-gd
else
	yum-config-manager --enable remi-php$PHP_VERSION
	yum_install php php-devel php-pear php-mysql php-mbstring php-gd
fi

  
#부팅시 실행되도록 설정
if [ $OS = "centos7" ]; then
	systemctl enable httpd
	systemctl enable mariadb
else
	chkconfig httpd on  
	chkconfig mysqld on
fi

  
