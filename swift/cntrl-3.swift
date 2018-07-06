
/**
   CONTROL 3 SWIFT
   Simple write to FS
*/

import files;
import io;
import sys;

import make_data;

printf("WORKFLOW: cntrl-3");
printf("WORKERS=%i", turbine_workers());
M = 10;
printf("N=%i", M*turbine_workers());

(string s) make_filename(int a, int b)
{
  s = "data/f-%i-%i.txt" % (a,b);
}

// For 3a: d=1
// For 3b: d=1024
d = 1;
printf("DATA SIZE: %i", d);

int A[int];
starttime = clock();
wait(starttime) {
    printf("Start time = %f", starttime);
    foreach j in [0:M-1]
    {
        int W[];
        foreach r in [0:turbine_workers()-1]
        {
            name = make_filename(j,r);
            file f<name> = make_data(d) =>
                W[r] = 0;
        }
        wait deep(W) { A[j] = 0; }
    }
}

wait deep(A) {
    endtime = clock() =>
        printf("end time = %f", endtime);
}
