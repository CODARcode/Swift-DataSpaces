# Swift-DataSpaces
Usage: ./run-workflow.sh 4

You will need to replace the LAUNCH variable with the directory where your launch.tcl is located.

Currently, all parameters are fixed in the swift script. This will run 1 server, 1 writer, 1 reader and do 10 iterations exchanging a 256x256x256 array of doubles. All output goes to stdout, and simply gives transfer timing information.
