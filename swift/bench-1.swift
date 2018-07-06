
/**
   Bench 1 SWIFT
   Simple put/get
*/

import io;
import sds;
import sys;

printf("WORKFLOW: bench-1");
printf("WORKERS=%i", turbine_workers());
N = turbine_workers() * 10;
printf("N=%i", N);
string A[int];
starttime = clock();
wait(starttime) {
    printf("Start time = %f", starttime);
    foreach i in [0:N-1]
    {
        sds_kv_put_sync("key"+i, "valueue1")
        =>
            A[i] = sds_kv_get("key"+i, 100);
    }
}

wait deep(A) {
    endtime = clock() =>
        printf("End time = %f", endtime);
}
