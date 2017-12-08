#!/bin/bash
set -eu

# RUN TEST SDS BLUES
# Runs Swift/T tests on Blues
# The user provides the test number

if [ ${#*} != 1 ]
then
  echo "Provide a test number!"
  exit 1
fi

# Test number
T=$1

echo "Running Swift/T test $T ..."

THIS=$( cd $( dirname $0 ) ; /bin/pwd )
cd $THIS

export SWIFT_PATH=$PWD
export SDS_DEBUG=1

PATH=/home/wozniak/sfw/login/swift-t-ds/stc/bin:$PATH
which swift-t

export WALLTIME=00:01:00

# Hard coded to 3 node allocation
# Swift/T: 2 nodes, PPN=2
# DS: 1 node
swift-t -m pbs -l -n 3 \
        -t i:$THIS/init-ds.sh \
        -e SDS_DEBUG \
        test-sds-$T.swift
