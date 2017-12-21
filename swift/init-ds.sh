#!/bin/sh
set -eu

# INIT DS

# Turbine init script to set up a DataSpaces run

cp -v dataspaces.conf $TURBINE_OUTPUT
cd $TURBINE_OUTPUT
rm -f srv.lck conf *.log
