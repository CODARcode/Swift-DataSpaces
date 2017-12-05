#!/bin/sh
set -eu

# RUN TEST SDS
# Runs Swift/T tests
# The user provides the test number

if [ ${#*} != 1 ]
then
  echo "Provide a test number!"
  exit 1
fi

# Test number
T=$1

echo "Running Swift/T test $T ..."

export SWIFT_PATH=$PWD
export SDS_DEBUG=1

CLIENTS=3

dataspaces_server -s 1 -c $CLIENTS &
DS_SERVER_PID=${!}
echo "dataspaces_server running: DS_SERVER_PID=$DS_SERVER_PID"

# N ranks -> N-1 workers
swift-t -l -n $CLIENTS test-sds-$T.swift

echo "swift-t exited with success."
echo "killing dataspaces_server..."
kill -1 $DS_SERVER_PID
echo "killed PID=$DS_SERVER_PID."
