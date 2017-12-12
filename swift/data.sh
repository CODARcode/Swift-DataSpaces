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

for P in "WORKFLOW:" "Job ID" "^N=" "Elapsed"
do
  grep --max-count=1 "$P"  $OUTPUT 
done
