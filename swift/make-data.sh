#!/bin/bash
set -eu

# MAKE DATA SH

usage()
{
  cat <<EOF
usage: make-data.sh <N> <OUTPUT>
writes N lines of 1024 characters to OUTPUT
EOF
}

if [[ ${#*} != 2 ]]
then
  usage
  exit 1
fi

N=$1
OUTPUT=$2

mkdir -pv $( dirname $OUTPUT )

C=$(( 1024 / 5 )) # Using 5-character integers

{
  for (( i=0 ; i<N ; i++ ))
  do
    for (( j=0 ; j<C ; j++ ))
    do
      printf "%05i" $RANDOM
    done
    printf "%03i\n" $(( RANDOM % 1000 )) # Last 4 characters
  done
} > $OUTPUT
