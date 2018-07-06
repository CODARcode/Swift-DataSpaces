
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

printf("WORKFLOW: bench-3");
printf("WORKERS=%i", turbine_workers());
M = 10;
printf("N=%i", M*turbine_workers());

// value = read(input(getenv("THIS")/"data-1M.txt"));

MB = 1024*1024+1;

tmpdir = "/tmp" / getenv("USER") / "bench-3";

(string s) make_filename(string tmpdir, int a, int b)
{
  // s = tmpdir + "/f-%i-%i.txt" % (a,b);
  s = "/dev/shm/bench-3/f-%i-%i.txt" % (a,b);
}

// For 3a: d=1
// For 3b: d=1024
d = 1;
printf("DATA SIZE: %i", d);

int W[];
starttime = clock();
wait(starttime) {
    printf("Start time = %f", starttime);
    foreach j in [0:M-1]
    {
        file D[];
        foreach r in [0:turbine_workers()-1]
        {
            name = make_filename(j,r);
            location L = locationFromRank(r);
            file f<name> = @location=L make_data(d) => {
                @location=L sds_kvf_put_sync(name, name) =>
                    D[r] = f;
            }
        }
        wait deep (D) { W[j] = 0; }
    }
}

app cleanup(string tmpdir)
{
  (getenv("THIS")/"clean.sh") tmpdir ;
}

wait deep (W)
{
  foreach r in [0:turbine_workers()-1]
  {
    @location=locationFromRank(r) cleanup(tmpdir);
  }
  endtime = clock() =>
    printf("end time = %f", endtime);
}
