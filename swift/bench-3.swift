
/**
   BENCH 3 SWIFT
   Simple put/get with bigger data
*/

import files;
import io;
import location;
import sds;
import sys;

printf("WORKERS=%i", turbine_workers());
M = 10;
printf("N=%i", M*turbine_workers());

// value = read(input(getenv("THIS")/"data-1M.txt"));

MB = 1024*1024+1;

app (void v) task(string f, int kb)
{
  (getenv("THIS")/"make-data.sh") 1 f ;
  //  (getenv("THIS")/"probe.sh")
}

(string s) make_filename(int a, int b)
{
  s = "/tmp/bench-3/f-%i-%i.txt" % (a,b);
}

int W[];
foreach j in [0:M-1]
{
  int D[];
  foreach r in [0:turbine_workers()-1]
  {
    name = make_filename(j,r);
    location L = locationFromRank(r);
    v = @location=L task(name, 1) => {
      D[r] = zero(v);
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
