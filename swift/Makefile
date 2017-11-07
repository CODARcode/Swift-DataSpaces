
# SDS MAKEFILE

CC    = gcc
TCL_VERSION = 8.6
TCL   = /usr
TCL_INCLUDE = $(TCL)/include/tcl$(TCL_VERSION)
TCLSH = $(TCL)/bin/tclsh

DATASPACES = /home/wozniak/sfw/dataspaces-1.6.2

CPPFLAGS = -I $(TCL_INCLUDE) -I $(DATASPACES)/include
CFLAGS = -fPIC
LINKFLAGS = -L $(DATASPACES)/lib -l dataspaces

all: pkgIndex.tcl

sds_wrap.c: sds.i sds.h Makefile
	swig -o $(@) $(<)

sds_wrap.o sds.o: Makefile

libsds.so: sds_wrap.o sds.o 
	$(CC) -shared -o $(@) $(^) \
		$(LINKFLAGS)

pkgIndex.tcl: libsds.so Makefile
	echo TCLSH $(TCLSH)
	LEAF_PKG=sds LEAF_VERSION=0.0 \
	LEAF_SO=$(<) \
	$(TCLSH) ./make-package.tcl > $(@)

clean:
	rm -fv pkgIndex.tcl *.so *.o *_wrap.c
