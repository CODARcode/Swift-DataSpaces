#!/bin/sh
set -eux

if [ ${#} -lt 1 ]
then
  echo "Usage: $0 PROCS" 
  exit 1
fi

LAUNCH=$HOME/Downloads/mpix_launch_swift/src
PROCS=$1

stc -p -u -I ${LAUNCH} -r ${LAUNCH} workflow.swift 
turbine -n $PROCS workflow.tic 
