#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"


#localIP = hostname -I
#로컬 ip 넣는 부분은 일단 보류

cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.ori
sed -i 's/KeepAlive Off/KeepAlive On/' /etc/httpd/conf/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName 127.0.0.0:80/' /etc/httpd/conf/httpd.conf
sed -i 's/AddDefaultCharset UTF-8/#AddDefaultCharset UTF-8/' /etc/httpd/conf/httpd.conf

sed -i 's/DirectoryIndex index.html/DirectoryIndex index.html index.php/' /etc/httpd/conf/httpd.conf

#html에서 php 실행되도록
echo "
AddType application/x-httpd-php .php .html
AddType application/x-httpd-php-source .phps " >> /etc/httpd/conf/httpd.conf


echo "
<Directory /home/*/public_html>
    AllowOverride All
	Order allow,deny
	Allow from all
</Directory>" >> /etc/httpd/conf/httpd.conf

#php config
cp /etc/php.ini /etc/php.ini.ori
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/php.ini
sed -i 's/allow_call_time_pass_reference = Off/allow_call_time_pass_reference = On/' /etc/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/php.ini

#mysql
cp /etc/my.cnf /etc/my.cnf.ori
yes | cp -av "${ROOT_DIR}/mariadb/centos7/my.cnf" /etc/my.cnf


exit 0   

# 주의  /autoset/includes/function.sh: line 33: script/edit-config-http.sh: 허가 거부
#다음 명령이 실패하여, 설치가 중단되었습니다. (exit code: 126)
