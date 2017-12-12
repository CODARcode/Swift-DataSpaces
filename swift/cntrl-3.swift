
/**
   CONTROL 3 SWIFT
   Simple write to FS
*/

import files;
import io;
import sys;

import make_data;

printf("WORKERS=%i", turbine_workers());
M = 10;
printf("N=%i", M*turbine_workers());

(string s) make_filename(int a, int b)
{
  s = "data/f-%i-%i.txt" % (a,b);
}

d = 1024;

foreach j in [0:M-1]
{
  foreach r in [0:turbine_workers()-1]
  {
    name = make_filename(j,r);
    file f<name> = make_data(d);
  }
}
