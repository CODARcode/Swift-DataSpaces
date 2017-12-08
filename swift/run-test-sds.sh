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

# Clean up from previous runs
rm -f srv.lck conf *.log

dataspaces_server -s 1 -c $CLIENTS &
DS_SERVER_PID=${!}
echo "dataspaces_server running: DS_SERVER_PID=$DS_SERVER_PID"

## Give some time for the servers to load and startup
while [ ! -f conf ]; do
    sleep 1s
done
sleep 5s  # wait for server to fill in the conf file

# N ranks -> N-1 workers
swift-t -l -n $CLIENTS test-sds-$T.swift

echo "swift-t exited with success."
sleep 1

# Ensure dataspaces_server exited when Swift/T finalized the clients
if [ -f /proc/$DS_SERVER_PID ]
then
  echo "warning: dataspaces_server (PID=$DS_SERVER_PID) is still up"
fi
