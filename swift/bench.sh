#!/bin/zsh -f
set -eu

# BENCH 
# Runs Swift/T T.swift on any system
# Edit the MACHINE-SPECIFIC SETTINGS below for your machine
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

# START MACHINE-SPECIFIC SETTINGS

# Defaults:
MACHINE=""
LLP=""

# Blues:
# PATH=/soft/jdk/1.8.0_51/bin:$PATH
# PATH=/home/wozniak/sfw/blues/login/swift-t-ds/stc/bin:$PATH
MACHINE=( -m pbs )
export PROJECT="Workflow"

# Cori:
# PATH=/home/wozniak/sfw/blues/login/swift-t-ds/turbine/bin:$PATH
WOZNIAK=/global/homes/w/wozniak
SWIFT_T=$WOZNIAK/Public/sfw/compute/swift-t-2017-07-11
PATH=$SWIFT_T/stc/bin:$PATH
PATH=$SWIFT_T/turbine/bin:$PATH
MACHINE=( -m slurm )
# This will be inserted into the submit script:
export TURBINE_DIRECTIVE="#SBATCH --constraint=haswell\n#SBATCH --license=SCRATCH"
.  /etc/profile.d/modules.sh # Probably only Wozniak needs this
module load java/jdk1.8.0_51
export QUEUE=${QUEUE:-debug}
LLP=( -e LD_LIBRARY_PATH=$WOZNIAK/Public/sfw/R-3.4.0/lib64/R/lib )

# END MACHINE-SPECIFIC SETTINGS

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

# For bench-2, we want to set -Fwait-coalesce to disable coalescing
OPTZ=${OPTZ:-}

# Disable Turbine logging
export TURBINE_LOG=0

# Swift/T headers to check for updates
# UPTODATE=( -U sds.swift -U make_data.swift -U sink.swift )

stc $OPTZ $T.swift
# Turbine will actually run on DS_CLIENTS processes!
set -x
turbine -l \
        $MACHINE \
        -n $PROCS \
        -i $THIS/init-ds.sh \
        -e SDS_DEBUG \
        $LLP \
        $T.tic
