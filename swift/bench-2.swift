
/**
   BENCH 2 SWIFT
   Simple put/get with bigger data
*/

import io;
import files;
import sds;
import sys;

printf("WORKFLOW: bench-2");
printf("WORKERS=%i", turbine_workers());
N = turbine_workers() * 10;
printf("N=%i", N);

value = read(input(getenv("THIS")/"data-1M.txt"));

MB = 1024*1024+1;

string A[int];
starttime = clock();
wait(starttime) {
    printf("Start time = %f", starttime);
    foreach i in [0:N-1]
    {
        sds_kv_put_sync("key"+i, value)
        =>
            A[i] = sds_kv_get("key"+i, MB);
    }
}

wait deep(A) {
    endtime = clock() =>
        printf("End time = %f", endtime);
}
