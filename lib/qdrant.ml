type client = { host : string; port : int }

let default_client = { host = "localhost"; port = 6334 }

type code = Grpc.Status.code =
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

let status_of_grpc (grpc_status : Grpc.Status.t) : status =
  let code : code = Grpc.Status.code grpc_status in
  let message = Grpc.Status.message grpc_status in
  { code; message }

let create_connection t =
  let open Lwt.Syntax in
  (* Setup Http/2 connection *)
  let* addresses =
    Lwt_unix.getaddrinfo t.host (string_of_int t.port)
      [ Unix.(AI_FAMILY PF_INET) ]
  in
  let socket = Lwt_unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let* () = Lwt_unix.connect socket (List.hd addresses).Unix.ai_addr in
  let error_handler _ = print_endline "error" in
  H2_lwt_unix.Client.create_connection ~error_handler socket

let request connection mods ~req ~service ~rpc =
  let open Lwt.Syntax in
  let open Ocaml_protoc_plugin in
  let encode, decode = Service.make_client_functions mods in
  let enc = encode req |> Writer.contents in
  let+ result =
    Grpc_lwt.Client.call ~service ~rpc
      ~do_request:(H2_lwt_unix.Client.request connection ~error_handler:ignore)
      ~handler:
        (Grpc_lwt.Client.Rpc.unary enc ~f:(fun decoder ->
             let+ decoder = decoder in
             match decoder with
             | Some decoder -> (
                 Reader.create decoder |> decode |> function
                 | Ok v -> Some v
                 | Error e ->
                     failwith
                       (Printf.sprintf "Could not decode request: %s"
                          (Result.show_error e)))
             | None -> None))
      ()
  in
  match result with Ok (x, _) -> Ok x | Error err -> Error (status_of_grpc err)

let request_with_default ~default connection mods ~req ~service ~rpc =
  let open Lwt.Syntax in
  let+ result = request connection mods ~req ~service ~rpc in
  match result with
  | Ok (Some x) -> Ok x
  | Ok None -> Ok (default ())
  | Error err -> Error err

type health_check = Proto.Qdrant.Qdrant.HealthCheckReply.t = {
  title : string;
  version : string;
}

let health_check t =
  let open Lwt.Syntax in
  let* connection = create_connection t in
  request_with_default connection Proto.Qdrant.Qdrant.Qdrant.healthCheck
    ~req:(Proto.Qdrant.Qdrant.HealthCheckRequest.make ())
    ~default:Proto.Qdrant.Qdrant.HealthCheckReply.make ~service:"qdrant.Qdrant"
    ~rpc:"HealthCheck"

let list_collections t =
  let open Lwt.Syntax in
  let* connection = create_connection t in
  let+ result =
    request_with_default connection
      Proto.Collections_service.Qdrant.Collections.list
      ~req:(Proto.Collections_service.Qdrant.Collections.List.Request.make ())
      ~default:Proto.Collections_service.Qdrant.Collections.List.Response.make
      ~service:"qdrant.Collections" ~rpc:"List"
  in
  match result with
  | Error err -> Error err
  | Ok
      Proto.Collections.Qdrant.ListCollectionsResponse.{ collections; time = _ }
    ->
      Ok collections

type compression_ratio = Proto.Collections.Qdrant.CompressionRatio.t =
  | X4
  | X8
  | X16
  | X32
  | X64

type quantization_type = Proto.Collections.Qdrant.QuantizationType.t =
  | UnknownQuantization
  | Int8

type scalar_quantization = Proto.Collections.Qdrant.ScalarQuantization.t = {
  type' : quantization_type;
  quantile : float option;
  always_ram : bool option;
}

type product_quantization = Proto.Collections.Qdrant.ProductQuantization.t = {
  compression : compression_ratio;
  always_ram : bool option;
}

type hnsw_config_diff = Proto.Collections.Qdrant.HnswConfigDiff.t = {
  m : int option;
  ef_construct : int option;
  full_scan_threshold : int option;
  max_indexing_threads : int option;
  on_disk : bool option;
  payload_m : int option;
}

type wal_config_diff = Proto.Collections.Qdrant.WalConfigDiff.t = {
  wal_capacity_mb : int option;
  wal_segments_ahead : int option;
}

type optimizers_config_diff =
      Proto.Collections.Qdrant.OptimizersConfigDiff.t = {
  deleted_threshold : float option;
  vacuum_min_vector_number : int option;
  default_segment_number : int option;
  max_segment_size : int option;
  memmap_threshold : int option;
  indexing_threshold : int option;
  flush_interval_sec : int option;
  max_optimization_threads : int option;
}

type distance = Proto.Collections.Qdrant.Distance.t =
  | UnknownDistance
  | Cosine
  | Euclid
  | Dot

type vector_params = Proto.Collections.Qdrant.VectorParams.t = {
  size : int;
  distance : distance;
  hnsw_config : hnsw_config_diff option;
  quantization_config : quantization_config option;
  on_disk : bool option;
}

and quantization_config =
  [ `not_set
  | `Scalar of scalar_quantization
  | `Product of product_quantization ]

type vector_params_map_map_entry = string * vector_params option
type vector_params_map = vector_params_map_map_entry list

type vectors_config =
  [ `not_set | `Params of vector_params | `Params_map of vector_params_map ]

let create_collection ~(collection_name : string)
    ?(hnsw_config : hnsw_config_diff option)
    ?(wal_config : wal_config_diff option)
    ?(optimizers_config : optimizers_config_diff option)
    ?(shard_number : int option) ?(on_disk_payload : bool option)
    ?(timeout : int option) ~(vectors_config : vectors_config)
    ?(replication_factor : int option) ?(write_consistency_factor : int option)
    ?(init_from_collection : string option)
    ?(quantization_config : quantization_config option) t =
  let open Lwt.Syntax in
  let* connection = create_connection t in
  let+ result =
    request_with_default connection
      Proto.Collections_service.Qdrant.Collections.create
      ~req:
        (Proto.Collections_service.Qdrant.Collections.Create.Request.make
           ~collection_name ?hnsw_config ?wal_config ?optimizers_config
           ?shard_number ?on_disk_payload ?timeout ~vectors_config
           ?replication_factor ?write_consistency_factor ?init_from_collection
           ?quantization_config ())
      ~default:Proto.Collections_service.Qdrant.Collections.Create.Response.make
      ~service:"qdrant.Collections" ~rpc:"Create"
  in
  match result with
  | Error err -> Error err
  | Ok { result = true; time = _ } -> Ok ()
  | Ok { result = false; time = _ } ->
      Error (Grpc.Status.v Unknown |> status_of_grpc)

let delete_collection ~collection_name ?timeout t =
  let open Lwt.Syntax in
  let* connection = create_connection t in
  let+ result =
    request_with_default connection
      Proto.Collections_service.Qdrant.Collections.delete
      ~req:
        (Proto.Collections_service.Qdrant.Collections.Delete.Request.make
           ~collection_name ?timeout ())
      ~default:Proto.Collections_service.Qdrant.Collections.Delete.Response.make
      ~service:"qdrant.Collections" ~rpc:"Delete"
  in
  match result with
  | Error err -> Error err
  | Ok { result = true; time = _ } -> Ok ()
  | Ok { result = false; time = _ } -> Error (Grpc.Status.v Unknown |> status_of_grpc)
