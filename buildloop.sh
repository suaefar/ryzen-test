#!/bin/bash

function error() {
  echo $(date)" $1 FAILED!"
  exit 1
}

NAME="$1"
CDIR="$PWD"
WDIR="${CDIR}/buildloop.d/${NAME}/"
for ((I=0;1;I++)); do
  cd "${CDIR}" || exit 1
  echo $(date)" ${NAME} start ${I}"
  [ -e "${WDIR}" ] && rm -r "${WDIR}"
  mkdir -p "${WDIR}" || exit 1
  cd "${WDIR}" || exit 1
  ${CDIR}/gcc-7.1.0/configure --disable-multilib &> configure.log || error "configure ${NAME}"
  make -j 1 &> build.log || error "build ${NAME}"
done
