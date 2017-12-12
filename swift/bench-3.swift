
/**
   BENCH 3 SWIFT
   Simple put/get with /tmp caching
*/

import files;
import io;
import location;
import sds;
import sys;

import make_data;

printf("WORKERS=%i", turbine_workers());
M = 10;
printf("N=%i", M*turbine_workers());

// value = read(input(getenv("THIS")/"data-1M.txt"));

MB = 1024*1024+1;

(string s) make_filename(int a, int b)
{
  s = "/tmp/bench-3/f-%i-%i.txt" % (a,b);
}

d = 1024;

int W[];
foreach j in [0:M-1]
{
  file D[];
  foreach r in [0:turbine_workers()-1]
  {
    name = make_filename(j,r);
    location L = locationFromRank(r);
    file f<name> = @location=L make_data(d) => {
      D[r] = f;
      @location=L sds_kvf_put(name, name);
    }
  }
  wait (D) { W[j] = 0; }
}

app cleanup()
{
  (getenv("THIS")/"clean.sh") "/tmp/bench-3" ;
}

wait (W)
{
  foreach r in [0:turbine_workers()-1]
  {
    @location=locationFromRank(r) cleanup();
  }
}
