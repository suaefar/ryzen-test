#!/bin/bash

function error() {
  echo $(date)" $1 FAILED!"
  exit 1
}

NAME="$1"
CDIR="$PWD"
WDIR=$(mktemp -d -p ./buildloop.d) || exit 1
cd "$WDIR"
${CDIR}/gcc-7.1.0/configure --disable-multilib &> configure.log || exit 1
for ((I=0;1;I++)); do
  echo $(date)" $NAME start $I" 
  make -j 1 &> build.log || error "$NAME"
  make clean &> clean.log || error "$NAME"
done
