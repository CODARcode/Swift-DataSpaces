
# SDS MAKEFILE

CC    = mpicc

TCL_VERSION = 8.6
TCL_HOME    = /usr
TCL_INCLUDE = $(TCL_HOME)/include/tcl$(TCL_VERSION)
TCLSH = $(TCL_HOME)/bin/tclsh

DATASPACES = /home/wozniak/sfw/dataspaces-1.6.4

CPPFLAGS = -I $(TCL_INCLUDE) -I $(DATASPACES)/include
CFLAGS = -fPIC
LINKFLAGS = -L $(DATASPACES)/lib -l dspaces -l dscommon \
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
