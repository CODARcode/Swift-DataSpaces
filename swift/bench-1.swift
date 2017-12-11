
/**
   Bench 1 SWIFT
   Simple put/get
*/

import io;
import sds;
import sys;

printf("WORKERS=%i", turbine_workers());
N = turbine_workers() * 10;
printf("N=%i", N);

foreach i in [0:N-1]
{
  sds_kv_put("key"+i, "value1")
  =>
  sds_kv_get("key"+i, 100);
}
