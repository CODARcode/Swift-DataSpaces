#!/bin/bash

if [ ${#*} != 1 ]
then
  echo "Provide a I/O method!"
  exit 1
fi

# I/O method
IO=$1

#for worker_num in 1 2 3 4 6 8 12 16 24 32 48 64 96 128 192 256
for worker_num in 1
do
	export PROCS=$(( worker_num + 2 ))
	export DS_SERVERS=1
	export DS_CLIENTS=$(( PROCS-DS_SERVERS ))
	echo "I/O method: $IO" >> log_$IO.txt
	echo "Worker number: $worker_num" >> log_$IO.txt
	./bench.sh $IO >> log_$IO.txt
	echo "turbine-directory.txt:"
	cat turbine-directory.txt >> log_$IO.txt
	mv turbine-directory.txt turbine-directory_$(echo $IO)_$worker_num.txt
#	./data.sh $( cat turbine-directory.txt )/output.txt >> temp.txt
	echo "" >> log_$IO.txt
done

exit 0

