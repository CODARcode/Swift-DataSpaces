
# SDS MAKEFILE

# Be sure to use the same MPI for Swift/T and DataSpaces!

# If you know what MPI you want to use:
# CC = mpicc

# Blues:
# CC = /home/wozniak/Public/sfw/mpich-3.1.2/bin/mpicc
# Cori:
# Do: module swap PrgEnv-intel PrgEnv-gnu
CC = cc

TCL_VERSION = 8.6

# Ubuntu:
# TCL_HOME    = /usr
# Theta:
# TCL_HOME = /projects/Candle_ECP/swift/deps/tcl-8.6.6
# Blues:
# TCL_HOME = /home/wozniak/Public/sfw/tcl-8.6.4
# Cori:
TCL_HOME = /global/u1/w/wozniak/Public/sfw/tcl-8.6.6-cray

TCL_INCLUDE = $(TCL_HOME)/include/tcl$(TCL_VERSION)
TCLSH = $(TCL_HOME)/bin/tclsh$(TCL_VERSION)

# Dunedin:
# DATASPACES = /home/wozniak/sfw/dataspaces-1.6.4
# Theta:
# DATASPACES = /home/wozniak/Public/sfw/theta/dataspaces-1.6.4
# Blues:
# DATASPACES = /home/wozniak/sfw/blues/login/dataspaces-1.6.4
# Cori:
# DATASPACES = /global/u1/w/wozniak/sfw/dataspaces-1.6.5
# Or module load:
# /project/projectdirs/m3084/pdavis/cori/sw/modulefiles/dataspaces/1.6.5-shared

# Most machines:
# CPPFLAGS = -I $(TCL_INCLUDE) -I $(DATASPACES)/include
# CFLAGS = -fPIC
# LINKFLAGS = -L $(DATASPACES)/lib -l dspaces -l dscommon \
#  	-Wl,-rpath -Wl,$(DATASPACES)/lib

# Cori:
# DS_C = $(DATASPACES)/bin/dspaces_config
# or after module load:
DS_C = dspaces_config
DSPACES_INC=$(shell $(DS_C) -c)
DSPACES_LIB=$(shell $(DS_C) -l)

CPPFLAGS = -I $(TCL_INCLUDE) $(DSPACES_INC)
CFLAGS = -fPIC
LINKFLAGS = $(DSPACES_LIB) \
    -Wl,-rpath -Wl,$(DATASPACES)/lib

all: pkgIndex.tcl

sds_wrap.c: sds.i sds.h Makefile
	swig -o $(@) $(<)

sds_wrap.o sds.o: Makefile sds.h

libsds.so: sds_wrap.o sds.o
	$(CC) -shared -o $(@) $(^) \
		$(LINKFLAGS)

pkgIndex.tcl: libsds.so Makefile make-package.tcl
	@echo TCLSH $(TCLSH)
	LEAF_PKG=sds LEAF_VERSION=0.0 \
	LEAF_SO=$(<) \
	$(TCLSH) ./make-package.tcl > $(@)

clean:
	rm -fv pkgIndex.tcl *.so *.o *_wrap.c
