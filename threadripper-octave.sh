#!/bin/bash

NPROC=$1

[ -n "$NPROC" ] || NPROC=$(nproc)

for ((I=0;$I<$NPROC;I++)); do
  octave-cli generate_load.m &
done

wait

