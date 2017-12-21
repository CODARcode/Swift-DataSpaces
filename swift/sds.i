
// SDS.I for SWIG

%module sds

// Make SWIG accept type MPI_Comm
typedef int MPI_Comm;

%include "sds.h"
%{
  // Make SWIG accept type MPI_Comm
  // Comment this out for Blues:
  typedef int MPI_Comm;
  #include "sds.h"
%}
