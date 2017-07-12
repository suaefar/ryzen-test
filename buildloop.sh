#!/bin/bash

function error() {
  echo $(date)" ${1} failed"
  exit 1
}

NAME="$1"
CDIR="$PWD"
WDIR="${CDIR}/buildloop.d/${NAME}/"
for ((I=0;1;I++)); do
  cd "${CDIR}" || error "leave workdir"
  echo $(date)" start ${I}"
  [ -e "${WDIR}" ] && rm -r "${WDIR}"
  mkdir -p "${WDIR}" || error "create workdir"
  cd "${WDIR}" || error "change to workdir"
  ${CDIR}/gcc-7.1.0/configure --disable-multilib &> configure.log || error "configure"
  make -j 1 &> build.log || error "build"
done
