
/**
   CONTROL 2 SWIFT
   Simple put/get with bigger data
*/

import io;
import files;
import sys;

import sink;

printf("WORKFLOW: cntrl-2");
printf("WORKERS=%i", turbine_workers());
N = turbine_workers() * 10;
printf("N=%i", N);

value = read(input(getenv("THIS")/"data-1M.txt"));

string A[int];
starttime = clock();

wait(starttime) {
    printf("Start time = %f", starttime);
    foreach i in [0:N-1]
    {
        file f<"data/key"+i> = write(value);
        string s = read(f);
        sink(s);
        A[i] = s;
    }
}

wait deep(A) {
    endtime = clock() =>
        printf("End time = %f", endtime);
}
