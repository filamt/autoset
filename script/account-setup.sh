#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"


if [ $# -ne 3 ];then
	echo  "사용법 account-setup.sh ID PASS DOMAIN"
	exit 1;
fi


#check id
    tmp_uid=`id -u $1`
    if [ -n "$tmp_uid" ]
    then
         echo "error!! already use $1 change it and try again"
         exit 1;
    fi

#domain check
VHOST_CNT=find /etc/httpd/conf.d/vhost.conf | xargs grep '$3' | wc -l

echo "vhost_cnt=$VHOST_CNT"
#exit 1;

#make id
	/usr/sbin/useradd $1 -d /home/$1 -G users
	echo $2 | /usr/bin/passwd --stdin $1
	/bin/chmod 701 /home/$1
	echo "complete"

#make db
	touch /tmp/db_setup_temp
	echo "create database $1;" > /tmp/db_setup_temp
	echo "grant all privileges on $1.* to $1@localhost identified by '$2';" >> /tmp/db_setup_temp
	echo "flush privileges;" >> /tmp/db_setup_temp
	/usr/bin/mysql -u root -p"$DBPASS" mysql < /tmp/db_setup_temp

#config vhost

echo "
<VirtualHost *:80>
        ServerAdmin postmaster@$3
        DocumentRoot /home/$1/public_html
        ServerName $3
#        ServerAlias www.$3
        ErrorLog /var/log/httpd/$3-error_log
        CustomLog /var/log/httpd/$3-access_log common env=!CodeRedNimda
</VirtualHost>
" >> /etc/httpd/conf.d/vhost.conf

/usr/sbin/apachectl restart 2>&1


exit;
