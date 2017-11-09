
/**
   sds.c   
*/

#include <dataspaces.h>

#include <stdio.h>
#include <string.h>

#include "sds.h"

#include <mpi.h>

int
sds_init(MPI_Comm comm, int nprocs)
{
  printf("dspaces_init\n");
  int id = 1;
  int rank, size;
  MPI_Comm_size(comm, &size);
  printf("size: %i\n",size);
  
  int rc = dspaces_init(2, id, &comm, NULL);
  if (rc != 0)
  {
    printf("dspaces_init failed!\n");
    return 1;
  }
  printf("dspaces_init returned\n"); fflush(stdout);
  return 0;
}

void
sds_kv_put(const char* var_name, const char* data)
{
  uint64_t bound = 0;
  int size = strlen(data);
  dspaces_put(var_name, 0, size, 1, &bound, &bound, data);
}

char*
sds_kv_get(const char* var_name)
{
  uint64_t bound = 0;
  char data[100];
  dspaces_get(var_name, 0, 2, 1, &bound, &bound, data);
  return strdup(data);
}

void 
sds_finalize()
{
  dspaces_finalize();
}
