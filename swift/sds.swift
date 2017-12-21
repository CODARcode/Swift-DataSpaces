
/*
  SDS SWIFT
*/

@dispatch=WORKER
(void v)
sds_kv_put(string key, string value)
"sds" "0.0"
[ "sds_kv_put <<key>> <<value>>" ];

@dispatch=WORKER
(void v)
sds_kv_put_sync(string key, string value)
"sds" "0.0"
[ "sds_kv_put <<key>> <<value>>" ];

@dispatch=WORKER
(string value)
sds_kv_get(string key, int max_size)
"sds" "0.0"
[ "set <<value>> [ sds_kv_get <<key>> <<max_size>> ]" ];

@dispatch=WORKER
(void v)
sds_kvf_put(string key, string fname)
"sds" "0.0"
[ "sds_kvf_put <<key>> <<fname>>" ];

@dispatch=WORKER
(string value)
sds_kvf_get(string key, int max_size, string fname)
"sds" "0.0"
[ "set <<value>> [ sds_kvf_get <<key>> <<max_size>> <<fname>> ]" ];
