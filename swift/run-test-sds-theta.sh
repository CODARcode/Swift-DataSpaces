#!/bin/bash
set -eu

# RUN TEST SDS THETA
# Runs Swift/T tests on Theta
# The user provides the test number

if [ ${#*} != 1 ]
then
  echo "Provide a test number!"
  exit 1
fi

# Test number
T=$1

echo "Running Swift/T test $T ..."

THIS=$( dirname $0 )
cd $THIS

export SWIFT_PATH=$PWD
export SDS_DEBUG=1

PATH=/home/wozniak/Public/sfw/theta/swift-t-ds/stc/bin:$PATH
which swift-t

export PROJECT=ecp-testbed-01 \
       QUEUE=debug-cache-quad \
       WALLTIME=00:01:00

# Hard coded to 3 node allocation
# Swift/T: 2 nodes, PPN=2
# DS: 1 node
swift-t -m theta -l -n 3 \
        -t i:$HOME/mcs/ste/setup-ds.sh \
        -e SDS_DEBUG \
        test-sds-$T.swift
