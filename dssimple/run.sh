#!/bin/bash

NS=1
NP=2

rm -f conf output.*

mpiexec -n ${NS} dataspaces_server -s ${NS} -c ${NP} &>server.log &

## Give some time for the servers to load and startup
while [ ! -f conf ]; do
    sleep 1s
done
sleep 5s  # wait server to fill up the conf file

mpiexec -n ${NP} ./simple_client  
