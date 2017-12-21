
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

foreach i in [0:N-1]
{
  file f<"data/key"+i> = write("value1");
  string s = read(f);
  sink(s);
}
