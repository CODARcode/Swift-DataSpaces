
/**
   sds.c
*/

#include <dataspaces.h>

#include <assert.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "sds.h"

#include <mpi.h>

/** If 1, be verbose */
static int debug = 0;

static void setup_debug(void);

/**
  Asserts that condition is true, else aborts.
*/
#define CHECK_MSG(condition, args...)                          \
  { if (!(condition)) {                                         \
      printf("CHECK FAILED: %s:%i\n", __FILE__, __LINE__);     \
      printf(args);                                             \
      printf("\n");                                             \
      exit(1); }}

int
sds_init(MPI_Comm comm, int nprocs)
{
  int id = 1;

  setup_debug();

  int mpi_size;
  MPI_Comm_size(comm, &mpi_size);

  int rc = dspaces_init(mpi_size, id, &comm, NULL);
  CHECK_MSG(rc == 0, "dspaces_init failed!");

  return 0;
}

/** Enable debugging if the environment has SDS_DEBUG=1 */
static void
setup_debug()
{
  char* t = getenv("SDS_DEBUG");
  if (t != NULL)
    if (strncmp(t, "1", 1) == 0)
      debug = 1;
}

/** Debugging printer */
static inline void
debugf(const char* format, ...)
{
  if (debug == 0) return;

  va_list va;
  va_start(va, format);

  // Append newline
  int length = strlen(format);
  char formatn[length+2];
  strcpy(formatn, format);
  formatn[length]   = '\n';
  formatn[length+1] = '\0';

  vprintf(formatn, va);
  va_end(va);
}

void
sds_kv_put_sync(const char* var_name, const char* data)
{
  debugf("sds_kv_put: %s=%s", var_name, data);
  uint64_t bound = 0;
  int size = strlen(data);
  int rc = dspaces_put(var_name, 0, size, 1, &bound, &bound, data);
  CHECK_MSG(rc == 0, "dspaces_put(%s) failed!\n", var_name);
  rc = dspaces_put_sync();
  CHECK_MSG(rc == 0, "dspaces_put_sync() failed!\n", var_name);
}

void
sds_kv_put(const char* var_name, const char* data)
{
  debugf("sds_kv_put: %s=%s", var_name, data);
  uint64_t bound = 0;
  int size = strlen(data);
  int rc = dspaces_put(var_name, 0, size, 1, &bound, &bound, data);
  CHECK_MSG(rc == 0, "dspaces_put(%s) failed!\n", var_name);
}

void
sds_kvf_put(const char* var_name, const char* filename)
{
  debugf("sds_kvf_put: %s=%s", var_name, filename);
  uint64_t bound = 0;

  // Stat
  struct stat sb;
  int rc;
  rc = stat(filename, &sb);
  CHECK_MSG(rc == 0, "sds_kvf_put(): could not stat: %s\n", filename);

  // Check size
  off_t max_size = INT_MAX;
  CHECK_MSG(sb.st_size < max_size,
             "sds_kvf_put(): file too big: %s\n", filename);

  int size = (int) sb.st_size;

  char* data = malloc(size);
  assert(data != NULL);
  FILE* fp = fopen(filename, "r");
  CHECK_MSG(fp != NULL,
            "sds_kvf_put(): could not open: %s\n", filename);
  int count = fread(data, 1, size, fp);
  CHECK_MSG(count == size,
            "sds_kvf_put(): short read: %s (%i)\n", filename, count);

  rc = dspaces_put(var_name, 0, size, 1, &bound, &bound, data);
  CHECK_MSG(rc == 0, "dspaces_put(%s) failed!\n", var_name);
  rc = dspaces_put_sync();
  CHECK_MSG(rc == 0, "dspaces_put_sync() failed!\n");
}

void
sds_kvf_put_sync(const char* var_name, const char* filename)
{
  debugf("sds_kvf_put: %s=%s", var_name, filename);
  uint64_t bound = 0;

  // Stat
  struct stat sb;
  int rc;
  rc = stat(filename, &sb);
  CHECK_MSG(rc == 0, "sds_kvf_put(): could not stat: %s\n", filename);

  // Check size
  off_t max_size = INT_MAX;
  CHECK_MSG(sb.st_size < max_size,
             "sds_kvf_put(): file too big: %s\n", filename);

  int size = (int) sb.st_size;

  char* data = malloc(size);
  assert(data != NULL);
  FILE* fp = fopen(filename, "r");
  CHECK_MSG(fp != NULL,
            "sds_kvf_put(): could not open: %s\n", filename);
  int count = fread(data, 1, size, fp);
  CHECK_MSG(count == size,
            "sds_kvf_put(): short read: %s (%i)\n", filename, count);

  rc = dspaces_put(var_name, 0, size, 1, &bound, &bound, data);
  CHECK_MSG(rc == 0, "dspaces_put(%s) failed!\n", var_name);
}


char*
sds_kv_get(const char* var_name, int max_size)
{
  debugf("sds_kv_get: %s (%i)", var_name, max_size);

  uint64_t bound = 0;
  char data[max_size+1];
  int rc = dspaces_get(var_name, 0, max_size, 1, &bound, &bound, data);
  CHECK_MSG(rc == 0, "dspaces_get(%s) failed!\n", var_name);
  data[max_size] = '\0';

  debugf("sds_kv_got: %s=%s", var_name, data);
  return strdup(data);
}

int
sds_kvf_get(const char* var_name, int max_size, const char* filename)
{
  debugf("sds_kv_get: %s (%i)", var_name, max_size);

  FILE* fp = fopen(filename, "w");
  CHECK_MSG(fp != NULL,
            "sds_kvf_get(): could not open: %s\n", filename);
  uint64_t bound = 0;
  char data[max_size+1];
  int rc;
  rc = dspaces_get(var_name, 0, max_size, 1, &bound, &bound, data);
  data[max_size] = '\0';

  int length = strlen(data);
  rc = fwrite(data, 1, length, fp);
  CHECK_MSG(rc = length,
            "sds_kvf_get(): short write: %s\n", filename);

  return length;
}

void
sds_finalize()
{
  debugf("calling dspaces_finalize()...");
  dspaces_finalize();
}
