#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"


yum makecache
yum -y --exclude=kernel* update
yum_install epel-release yum-utils ntp rdate nmap smartmontools wget openssh-clients expect

if [ $OS = "centos7" ]; then
  systemctl enable ntpd
  systemctl start ntpd
else
  chkconfig ntpd on
  service ntpd start
fi

ntpdate -u kr.pool.ntp.org 0.centos.pool.ntp.org pool.ntp.org

if [ ${?} != "0" ]; then
  outputError "Warning) 시간 자동 동기화가 실패하였습니다.\n  ntpdate -u kr.pool.ntp.org 0.centos.pool.ntp.org pool.ntp.org"
  exit 0  # 실패시에도 설치 계속 진행
fi

	
#계정 셋팅시 필요한 작업
mkdir /etc/skel/public_html
echo "welcome!!!!" > /etc/skel/public_html/index.html

#open file 수정

echo "*               soft    nofile          65535 
*               hard    nofile          65535 " >> /etc/security/limits.conf

 