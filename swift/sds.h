
/**
   SDS: Swift-DataSpaces

   Simplified interface for SWIG
*/

#ifndef SWIG
#include <mpi.h>
#endif

/** @return 0 on success, 1 on error */
int   sds_init(MPI_Comm comm, int nprocs);
char* sds_kv_get(const char* var_name);
void  sds_kv_put(const char* var_name, const char* data);
void  sds_finalize(void);
