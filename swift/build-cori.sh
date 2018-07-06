#!/bin/bash -l
set -eu

# Build the SDS module on Cori

module purge
module load modules
module load craype craype-haswell cray-mpich
module load PrgEnv-gnu
module load /project/projectdirs/m3084/pdavis/cori/sw/modulefiles/dataspaces/1.6.5-shared

log_path()
# Pretty print a colon-separated variable
{
  echo ${1}:
  eval echo \$$1 | tr : '\n' | nl
}

# log_path PATH

make -f Makefile.cori
