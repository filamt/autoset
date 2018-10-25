#!/usr/bin/env bash

ROOT_DIR=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${ROOT_DIR}/includes/function.sh"

sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# exit status code 를 1로 반환하여, 설치가 중단되므로 강제로 0으로 반환
/usr/sbin/setenforce 0
exit 0 