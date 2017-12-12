#!/bin/bash
#    Begin SBATCH directives
#SBATCH -p debug
#SBATCH -N 4
#SBATCH -C haswell
#SBATCH -J test-sds
#SBATCH -t 00:05:00
#SBATCH -V
#    End SBATCH directives and begin shell commands

set -eu

# RUN TEST SDS
# Runs Swift/T tests
# The user provides the test number

# Test number
T=1

echo "Running Swift/T test $T ..."

export SWIFT_PATH=$PWD
export SDS_DEBUG=1
export TURBINE_LOG=1

CLIENTS=3

rm -f conf cred srv.lck

srun -n 1 -N 1 -c 32 dataspaces_server -s 1 -c $CLIENTS &> server.log &
DS_SERVER_PID=${!}
echo "dataspaces_server running: DS_SERVER_PID=$DS_SERVER_PID"

sleep 10

# N ranks -> N-1 workers
#stc test-sds-1.swift 
#turbine -V -n 3 test-sds-1.tic &> turbine.log
swift-t -V -l -n $CLIENTS test-sds-$T.swift &> swift.log

echo "swift-t exited with success."
echo "killing dataspaces_server..."
kill -1 $DS_SERVER_PID
echo "killed PID=$DS_SERVER_PID."
