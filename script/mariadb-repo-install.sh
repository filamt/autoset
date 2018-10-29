#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"

if [ ! -f /etc/yum.repos.d/MariaDB.repo ]; then
  if [ $OS = "centos7" ]; then
    cp -av "${ROOT_DIR}/mariadb/centos7/MariaDB.repo" /etc/yum.repos.d/
  else
    cp -av "${ROOT_DIR}/mariadb/centos6/MariaDB.repo" /etc/yum.repos.d/
  fi
fi
  