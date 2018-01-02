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
	echo "I/O method: $IO" >> result_$IO.txt
	echo "Worker number: $worker_num" >> result_$IO.txt
	./data.sh $( cat turbine-directory_$(echo $IO)_$worker_num.txt )/output.txt >> result_$IO.txt
	echo "" >> result_$IO.txt
done

exit 0

