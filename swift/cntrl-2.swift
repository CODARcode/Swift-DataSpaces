
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

foreach i in [0:N-1]
{
  file f<"data/key"+i> = write(value);
  string s = read(f);
  sink(s);
}
