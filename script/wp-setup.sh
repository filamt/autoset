#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"


if [ $# -ne 3 ];then
	echo  "사용법 account-setup.sh ID PASS DOMAIN"
	exit 1;
fi



###############################################
###   wordpress 자동설치   #######################
###############################################

sudo -u $1 -i /usr/local/bin/wp core download --path=/home/$1/public_html --locale=ko_KR
sudo -u $1 -i /usr/local/bin/wp config create --dbname=$1 --dbuser=$1 --dbpass=$2 --dbhost=localhost --dbprefix=wp_ --path=/home/$1/public_html
sudo -u $1 -i /usr/local/bin/wp core install --url=$3 --title="팔만볼트" --admin_user=$1 --admin_password=$2 --admin_email='wordpress@80000v.co.kr' --path=/home/$1/public_html

#플러그인 설치
#sudo -u $1 -i /usr/local/bin/wp theme install stout --activate --path=/home/$1/public_html

exit 0 ;
