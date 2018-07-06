#!/bin/bash -l
set -eu

# BENCH CORI
# Runs Swift/T T.swift on Cori
# The user provides the test name and
# sets env vars DS_CLIENTS and DS_SERVERS.
# This script will set PROCS = DS_CLIENTS + DS_SERVERS

if [[ ${#*} != 1 ]]
then
  echo "Provide a test name!"
  exit 1
fi

# Test name
T=$1

echo "Running Swift/T test $T ..."

export THIS=$( cd $( dirname $0 ) ; /bin/pwd )
cd $THIS
pwd

# Find the SDS package
export SWIFT_PATH=$PWD
# Set SDS debug logging
export SDS_DEBUG=0

# Set up modules
module load java

# Set up PATH
SWIFT=~wozniak/Public/sfw/compute/swift-t-ds
PATH=$SWIFT/stc/bin:$PATH
PATH=$SWIFT/turbine/bin:$PATH

if [[ ${DS_CLIENTS:-} == "" ]] || \
   [[ ${DS_SERVERS:-} == "" ]]
then
  echo "Set DS_CLIENTS and DS_SERVERS!"
  exit 1
fi

# Sanity check user settings
if ! (( $DS_CLIENTS > 1 ))
then
  echo "User error!"
  echo "DS_CLIENTS=$DS_CLIENTS must be greater than 1."
  exit 1
fi

# For bench-2, we want to set -Fwait-coalesce to disable coalescing
OPTZ=${OPTZ:-}

# Swift/T headers to check for updates
UPTODATE=( -U sds.swift -U make_data.swift -U sink.swift )

which swift-t stc turbine

# Run STC
stc $OPTZ ${UPTODATE[@]} $T.swift

# Turbine settings
# Turbine will actually run on DS_CLIENTS processes!
PROCS=$(( $DS_CLIENTS + $DS_SERVERS ))
export WALLTIME=00:05:00

export TURBINE_DIRECTIVE="#SBATCH -C knl,quad,cache\n#SBATCH --license=SCRATCH"
export QUEUE=debug
export PPN=1
export TURBINE_LOG=0
LD_LIBRARY_PATH=$HOME/Public/sfw/R-3.4.0/lib64/R/lib

# Run Turbine
set -x
turbine -m slurm -l \
        -n $PROCS \
        -i $THIS/init-ds.sh \
        -e SDS_DEBUG \
        -e LD_LIBRARY_PATH=$LD_LIBRARY_PATH \
        $T.tic
#         hi.tcl

#        $T.tic
