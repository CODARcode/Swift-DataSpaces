#!/bin/bash
set -eu

# RUN TEST DS TCL

# Runs the pure Tcl DS test

source $( turbine -c )
export TCLLIBPATH="$PWD $TURBINE_HOME/lib"
mpiexec -l -n 2 tclsh $PWD/test-ds.tcl
