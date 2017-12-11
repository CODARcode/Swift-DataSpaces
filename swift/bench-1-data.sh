#!/bin/sh
set -eu

if [ ${#} != 1 ]
then
  echo "Provide OUTPUT file!"
  exit 1
fi

OUTPUT=$1

for P in "Job ID" "^N=" "Elapsed"
do
  grep --max-count=1 "$P"  $OUTPUT 
done
