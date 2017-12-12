#!/bin/zsh -f
set -eu

# BENCH BLUES
# Runs Swift/T bench-*.swift on Blues
# The user provides the test name and
# sets env vars PROCS, DS_CLIENTS, and DS_SERVERS
# such that PROCS = DS_CLIENTS + DS_SERVERS
# We use ZSH for an array convenience at the end

if [ ${#*} != 1 ]
then
  echo "Provide a test name!"
  exit 1
fi

# Test name
T=$1

echo "Running Swift/T test $T ..."

export THIS=$( cd $( dirname $0 ) ; /bin/pwd )
cd $THIS

# Find the SDS package
export SWIFT_PATH=$PWD
# Set SDS debug logging
export SDS_DEBUG=0

# Set up PATH
PATH=/soft/jdk/1.8.0_51/bin:$PATH
PATH=/home/wozniak/sfw/blues/login/swift-t-ds/stc/bin:$PATH
PATH=/home/wozniak/sfw/blues/login/swift-t-ds/turbine/bin:$PATH
which swift-t

export WALLTIME=00:01:00

# Sanity check user settings
if (( $DS_CLIENTS < 2 ))
then
  echo "User error!"
  echo "DS_CLIENTS=$DS_CLIENTS must be greater than 1."
  exit 1
fi
if (( $PROCS != $DS_CLIENTS + $DS_SERVERS ))
then
  echo "User error!"
  echo PROCS=$PROCS "!=" DS_CLIENTS=$DS_CLIENTS + DS_SERVERS=$DS_SERVERS
  exit 1
fi

OPTZ=${OPTZ:-}

# export TURBINE_LOG=1

# Swift/T headers to check for updates
UPTODATE=( -U sds.swift -U make_data.swift -U sink.swift )

stc $OPTZ ${UPTODATE} $T.swift
# Turbine will actually run on DS_CLIENTS processes!
set -x
turbine -m pbs -l \
        -n $PROCS \
        -i $THIS/init-ds.sh \
        -e SDS_DEBUG \
        $T.tic
