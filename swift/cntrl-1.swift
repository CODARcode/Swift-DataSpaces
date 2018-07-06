
/**
   CONTROL 1
   Simple put/get
*/

import io;
import files;
import sys;

import sink;

printf("WORKFLOW: cntrl-1");
printf("WORKERS=%i", turbine_workers());
N = turbine_workers() * 10;
printf("N=%i", N);

string A[int];

starttime = clock();
wait(starttime) {
    printf("starttime = %f", starttime);
    foreach i in [0:N-1]
    {
        file f<"data/key"+i> = write("valueue1");
        A[i] = read(f);
        sink(A[i]);
    }

}

wait deep(A) {
    endtime = clock() =>
    printf("endtime = %f", endtime);
}
