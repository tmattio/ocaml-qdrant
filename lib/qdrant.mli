type client = { host : string; port : int }

val default_client : client

type health_check = { title : string; version : string }

val health_check : client -> (health_check, Grpc.Status.t) result Lwt.t
val list_collections : client -> (string list, Grpc.Status.t) result Lwt.t

type compression_ratio = X4 | X8 | X16 | X32 | X64
type quantization_type = UnknownQuantization | Int8

type scalar_quantization = {
  type' : quantization_type;
  quantile : float option;
  always_ram : bool option;
}

type product_quantization = {
  compression : compression_ratio;
  always_ram : bool option;
}

type hnsw_config_diff = {
  m : int option;
  ef_construct : int option;
  full_scan_threshold : int option;
  max_indexing_threads : int option;
  on_disk : bool option;
  payload_m : int option;
}

type wal_config_diff = {
  wal_capacity_mb : int option;
  wal_segments_ahead : int option;
}

type optimizers_config_diff = {
  deleted_threshold : float option;
  vacuum_min_vector_number : int option;
  default_segment_number : int option;
  max_segment_size : int option;
  memmap_threshold : int option;
  indexing_threshold : int option;
  flush_interval_sec : int option;
  max_optimization_threads : int option;
}

type distance = UnknownDistance | Cosine | Euclid | Dot

type vector_params = {
  size : int;
  distance : distance;
  hnsw_config : hnsw_config_diff option;
  quantization_config : quantization_config option;
  on_disk : bool option;
}

and quantization_config =
  [ `Product of product_quantization
  | `Scalar of scalar_quantization
  | `not_set ]

type vector_params_map_map_entry = string * vector_params option
type vector_params_map = vector_params_map_map_entry list

type vectors_config =
  [ `Params of vector_params | `Params_map of vector_params_map | `not_set ]

val create_collection :
  collection_name:string ->
  ?hnsw_config:hnsw_config_diff ->
  ?wal_config:wal_config_diff ->
  ?optimizers_config:optimizers_config_diff ->
  ?shard_number:int ->
  ?on_disk_payload:bool ->
  ?timeout:int ->
  vectors_config:vectors_config ->
  ?replication_factor:int ->
  ?write_consistency_factor:int ->
  ?init_from_collection:string ->
  ?quantization_config:quantization_config ->
  client ->
  (unit, Grpc.Status.t) result Lwt.t

val delete_collection :
  collection_name:string ->
  ?timeout:int ->
  client ->
  (unit, Grpc.Status.t) result Lwt.t
