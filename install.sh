#!/usr/bin/env bash

ROOT_DIR=$( cd "$( dirname "$0" )" && pwd )

source "${ROOT_DIR}/includes/function.sh"

 
#init
cmd_once "script/init.sh"

# Disable SELinux (최초 설치시 진행하므로 일단 보류)
#cmd_once "script/selinux-disable.sh"

#remi-repo 설치
cmd_once "script/remi-repo-install.sh"

#디폴트 설치일 경우
#if [ $INSTALL_VER = "1" ]; then
  cmd_once "script/install-ver-default.sh"
#fi



#default config 파일 수정
cmd_once "script/edit-config-http.sh"


#http 실행
service httpd restart

#mysql 초기 비번 설정(default.conf에 설정)
cmd_once "script/mysql-secure-install.sh"
 