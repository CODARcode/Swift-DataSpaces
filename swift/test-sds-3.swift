
/**
   TEST SDS 3 SWIFT
   Simple put/get with server kill
*/

/* All of the location stuff can be removed - see the Readme */

import location;
import sds;

@location=locationFromRank(0)
sds_kv_put("key1", "value1")
  =>
  s =
  @location=locationFromRank(1)
  sds_kv_get("key1", 100)
  =>
  sds_kv_put("die!", "");

trace("s: ", s);
