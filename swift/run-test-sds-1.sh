#!/bin/sh
set -eu

export SWIFT_PATH=$PWD
export SDS_DEBUG=1

CLIENTS=3

dataspaces_server -s 1 -c $CLIENTS &
DS_SERVER_PID=${!}
echo "dataspaces_server running: DS_SERVER_PID=$DS_SERVER_PID"

# N ranks -> N-1 workers
swift-t -l -n $CLIENTS test-sds-1.swift

echo "killing dataspaces_server"
kill -1 $DS_SERVER_PID
