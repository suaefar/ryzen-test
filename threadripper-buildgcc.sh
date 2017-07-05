#!/bin/bash

NPROC=$1

[ -n "$NPROC" ] || NPROC=$(nproc)

[ -d 'buildloop.d' ] && rm -r 'buildloop.d'
mkdir -p buildloop.d

for ((I=0;$I<$NPROC;I++)); do
  ./buildloop.sh "loop-$I" &
  sleep 1
done

wait
