
/**
   TEST SDS 2 SWIFT
   Put from file, then get to file
*/

/* All of the location stuff can be removed - see the Readme */

import location;
import string;

import sds;

@location=locationFromRank(0)
sds_kvf_put("key1", "f-1M.txt")
  =>
  s =
  @location=locationFromRank(1)
  sds_kvf_get("key1", 100, "f-copy.txt");
