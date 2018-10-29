#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )

source "${ROOT_DIR}/includes/function.sh"


is_installed remi-release
if [ $FUNC_RESULT = "1" ]; then
    echo "Already installed. -> remi-release"
else
    if [ $OS = "centos7" ]; then
        yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    else
        yum -y install http://rpms.remirepo.net/enterprise/remi-release-6.rpm
    fi
fi

yum -y --enablerepo=remi update remi-release
yum-config-manager --enable remi | grep -P '\[remi|enabled ='
yum-config-manager --save --setopt=remi.exclude="php-* mysql-*" | grep -P '\[remi\]|exclude = php'
yum makecache
  