DSPACES_INC=$(shell dspaces_config -c)
DSPACES_LIB=$(shell dspaces_config -l)
simple_client: simple.c
	mpicc -g -o simple_client simple.c $(DSPACES_INC) $(DSPACES_LIB)

input:
	fortune > input

clean:
	rm -f simple_client *.o input
