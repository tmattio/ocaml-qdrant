(** {1 OCaml Qdrant} *)

(** {2 Client} *)

type client = { host : string; port : int }

val default_client : client

(** {2 Status Code} *)

type code =
  | OK
  | Cancelled
  | Unknown
  | Invalid_argument
  | Deadline_exceeded
  | Not_found
  | Already_exists
  | Permission_denied
  | Resource_exhausted
  | Failed_precondition
  | Aborted
  | Out_of_range
  | Unimplemented
  | Internal
  | Unavailable
  | Data_loss
  | Unauthenticated

type status = { code : code; message : string option }

(** {2 Health Check} *)

type health_check = { title : string; version : string }

val health_check : client -> (health_check, status) result Lwt.t

(** {2 Collections} *)

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
      (** Number of edges per node in the index graph. Larger the value - more accurate the search, more space required. *)
  ef_construct : int option;
      (** Number of neighbours to consider during the index building. Larger the value - more accurate the search, more time required to build the index. *)
  full_scan_threshold : int option;
      (**
        Minimal size (in KiloBytes) of vectors for additional payload-based indexing.
        If the payload chunk is smaller than `full_scan_threshold` additional indexing won't be used -
        in this case full-scan search should be preferred by query planner and additional indexing is not required.
        Note: 1 Kb = 1 vector of size 256 *)
  max_indexing_threads : int option;
      (** Number of parallel threads used for background index building. If 0 - auto selection. *)
  on_disk : bool option;
      (** Store HNSW index on disk. If set to false, the index will be stored in RAM. *)
  payload_m : int option;
      (** Number of additional payload-aware links per node in the index graph. If not set - regular M parameter will be used. *)
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

val list_collections : client -> (string list, status) result Lwt.t

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
  (unit, status) result Lwt.t

val delete_collection :
  collection_name:string ->
  ?timeout:int ->
  client ->
  (unit, status) result Lwt.t
