#!/usr/bin/env bash

source "${ROOT_DIR}/includes/message.sh"
source "${ROOT_DIR}/includes/default.conf"
 
#check os
OS=
if [ -f /etc/centos-release ]; then
  RELEASE_VERSION=`grep -o 'release [0-9]\+' /etc/centos-release`
  if [ "$RELEASE_VERSION" = "release 7" ]; then
    OS=centos7
  elif [ "$RELEASE_VERSION" = "release 6" ]; then
    OS=centos6
  else
    echo "Only CentOS 6/7. (CentOS 6/7 버전만 지원됩니다.)"
    echo -n "Current version: " && cat /etc/centos-release
    abort
  fi
else
  echo "Only CentOS 6/7. (CentOS 6/7 버전만 지원됩니다.)"
  abort
fi


#설치됐었는지 확인여부 (리턴값이 0이면 이미 설치)
FUNC_RESULT=

# 실행시 에러가 존재할 경우 중단
CMD_EXIT_CODE=
function cmd
{
  #printf "${GREEN}run# ${1}${NO_COLOR}\n"
  eval ${1}
  CMD_EXIT_CODE=${?}
  if [ ${CMD_EXIT_CODE} != "0" ]; then
    outputError "다음 명령이 실패하여, 설치가 중단되었습니다. (exit code: ${CMD_EXIT_CODE})"
    printf "\n"
    outputError "# ${1}"
    printf "\n"
    exit 1
  fi
}

# 명령을 파일로 남길 수 있도록 특수 문자 제거
function escape_path()
{
   printf '%s' "${1}" | sed -e 's/[ \\\/^*+$]/\_/g'
}

# 성공한 경우 1회만 실행하여, 중복 실행 방지
function cmd_once
{
  LOCK="locks/$(escape_path "${1}")"
  if [ ! -f "${LOCK}" ]; then
    cmd "${1}"

    if [ ${CMD_EXIT_CODE} = "0" ]; then
      touch "${LOCK}"
    fi
  fi
}

function is_installed
{
  for i in "$@"
  do
    RESULT=`yum -C --noplugins -q list installed $i 2> /dev/null`
    if [[ ! $RESULT == *"$i"* ]]; then
      FUNC_RESULT=0
      return
    fi
  done

  FUNC_RESULT=1
}

#yum_install
function yum_install
{
  is_installed $@
  if [ $FUNC_RESULT = "1" ]; then
    #echo "Already installed. -> $@"
    echo -n
  else
    yum -y install $@
  fi
}
  