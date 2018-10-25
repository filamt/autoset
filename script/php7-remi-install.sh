#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"

title "PHP [${1}] 버전을 설치합니다."

if [ -z ${1} ]; then
  abort "설치할 PHP 버전을 입력하세요.  70 72"
fi

yum_install php$1-php-cli php$1-php-fpm \
php$1-php-common php$1-php-pdo php$1-php-mysqlnd php$1-php-mbstring php$1-php-mcrypt \
php$1-php-opcache php$1-php-xml php$1-php-pecl-imagick php$1-php-gd php$1-php-fileinfo \
php$1-php-pecl-mysql

if [ ! -f "/etc/opt/remi/php${1}/php.d/z-php79.ini" ]; then
  notice "PHP 권장 설정이 추가되었습니다.\n설정 파일 경로) /etc/opt/remi/php${1}/php.d/z-php79.ini"
  cp -av "${STACK_ROOT}/php/70/z-php79.ini" "/etc/opt/remi/php${1}/php.d/"
  string_quote ${TIMEZONE}
  sed -i "s/^date.timezone =.*/date.timezone = ${STRING_QUOTE}/g" "/etc/opt/remi/php${1}/php.d/z-php79.ini"
fi

PHP_FPM_CONF=/etc/opt/remi/php$1/php-fpm.d/www.conf
sed -i 's/^;security.limit_extensions = .php .php3 .php4 .php5/security.limit_extensions = .php .html .htm .inc/g' $PHP_FPM_CONF
sed -i 's/^user = apache/user = apache/g' $PHP_FPM_CONF
sed -i 's/^group = apache/group = apache/g' $PHP_FPM_CONF
sed -i 's/^listen = 127.0.0.1:9000/listen = 127.0.0.1:90'$1'/g' $PHP_FPM_CONF

chgrp -v apache /var/opt/remi/php$1/lib/php/*
chown -v apache /var/opt/remi/php$1/log/php-fpm

if [ $OS = "centos7" ]; then
  systemctl enable php$1-php-fpm
  systemctl start php$1-php-fpm
else
  chkconfig php$1-php-fpm on
  service php$1-php-fpm start
fi

# nginx 설치된 경우만 복사
if [ -f /etc/nginx/conf.d/0-php79.conf ]; then
  if [ ! -f "/etc/nginx/conf.d/1-fastcgi-php${1}.conf" ]; then
    cp -av "${STACK_ROOT}/nginx/1-fastcgi-php${1}.conf" /etc/nginx/conf.d/
  fi
fi
