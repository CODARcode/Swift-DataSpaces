#!/bin/sh
set -eu

# DATA SH
# Extract performance data from output file

if [ ${#} != 1 ]
then
  echo "Provide OUTPUT file!"
  exit 1
fi

OUTPUT=$1

if ! [ -d $( dirname $OUTPUT ) ]
then
  echo "No output directory: $OUTPUT"
  exit 1
fi
i=0
while true
do
  if [ -f $OUTPUT ]
  then
    break
  else
    (( i = i+1 ))
    if (( i > 5 ))
    then
      echo "$OUTPUT not found!"
      exit 1
    fi
  fi
done

for P in "WORKFLOW:" "Job ID" "\\bN=" "Elapsed"
do
  if ! grep --max-count=1 "$P" $OUTPUT
  then
    echo "Error: Could not find pattern '$P'"
    exit 1
  fi
done

# This one is optional
grep "DATA SIZE:" $OUTPUT || true
