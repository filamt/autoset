#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"

title "PHP [${1}] 버전을 설치합니다."

yum_install MariaDB-server MariaDB-client

 
  
 