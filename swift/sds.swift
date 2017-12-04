
/*
  SDS SWIFT
*/

@dispatch=WORKER
(void v)
sds_kv_put(string key, string value)
"sds" "0.0"
[ "sds_kv_put <<key>> <<value>>" ];

@dispatch=WORKER
(string value)
sds_kv_get(string key, int max_size)
"sds" "0.0"
[ "set <<value>> [ sds_kv_get <<key>> <<max_size>> ]" ];
