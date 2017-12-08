#!/bin/sh

# SETUP DS

# Set up a DataSpaces run

cd $TURBINE_OUTPUT
cp -v ~/dataspaces.conf .
rm -f srv.lck conf *.log
