
/**
   sds.c   
*/

#include <dataspaces.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sds.h"

#include <mpi.h>

/** If 1, be verbose */
static int debug = 0;

static void setup_debug(void);

int
sds_init(MPI_Comm comm, int nprocs)
{
  int id = 1;

  setup_debug();
  
  int mpi_size;
  MPI_Comm_size(comm, &mpi_size);
  
  int rc = dspaces_init(mpi_size, id, &comm, NULL);
  if (rc != 0)
  {
    printf("dspaces_init failed!\n");
    return 1;
  }
  return 0;
}

static void setup_debug()
{
  char* t = getenv("SDS_DEBUG");
  if (t != NULL)
    if (strncmp(t, "1", 1) == 0)
      debug = 1;
}

void
sds_kv_put(const char* var_name, const char* data)
{
  if (debug)
    printf("sds_kv_put: %s=%s\n", var_name, data);
  uint64_t bound = 0;
  int size = strlen(data);
  int rc = dspaces_put(var_name, 0, size, 1, &bound, &bound, data);
  if (rc != 0)
  {
    printf("dspaces_put(%s) failed!\n", var_name);
    exit(1);
  }
}

char*
sds_kv_get(const char* var_name, int max_size)
{
  if (debug)
    printf("sds_kv_get: %s (%i)\n", var_name, max_size);

  uint64_t bound = 0;
  char data[max_size];
  int rc = dspaces_get(var_name, 0, max_size, 1, &bound, &bound, data);
  if (rc != 0)
  {
    printf("dspaces_get(%s) failed!\n", var_name);
    exit(1);
  }
  if (debug)
    printf("sds_kv_got: %s=%s\n", var_name, data);
  return strdup(data);
}

void 
sds_finalize()
{
  dspaces_finalize();
}
