
/**
   sds.c   
*/ 

#include <dataspaces.h>

#include <string.h>

void
sds_init()
{
  // dspaces_init(nprocs, 1, &gcomm, NULL);
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
