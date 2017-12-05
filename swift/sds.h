
/**
   SDS: Swift-DataSpaces

   Simplified interface for SWIG
*/

#ifndef SWIG
#include <mpi.h>
#endif

/** @return 0 on success, 1 on error */
int   sds_init(MPI_Comm comm, int nprocs);

char* sds_kv_get(const char* var_name, int max_size);
void  sds_kv_put(const char* var_name, const char* data);
int   sds_kvf_get(const char* var_name, int max_size, const char* filename);
void  sds_kvf_put(const char* var_name, const char* filename);

void  sds_finalize(void);
