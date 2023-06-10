type client = { host : string; port : int }

let default_client = { host = "localhost"; port = 6334 }

type health_check = Proto.Qdrant.Qdrant.HealthCheckReply.t = {
  title : string;
  version : string;
}

let health_check t =
  let open Lwt.Syntax in
  (* Setup Http/2 connection *)
  let* addresses =
    Lwt_unix.getaddrinfo t.host (string_of_int t.port)
      [ Unix.(AI_FAMILY PF_INET) ]
  in
  let socket = Lwt_unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let* () = Lwt_unix.connect socket (List.hd addresses).Unix.ai_addr in
  let error_handler _ = print_endline "error" in
  let* connection =
    H2_lwt_unix.Client.create_connection ~error_handler socket
  in

  (* code generation *)
  let open Ocaml_protoc_plugin in
  let encode, decode =
    Service.make_client_functions Proto.Qdrant.Qdrant.Qdrant.healthCheck
  in
  let enc = encode () |> Writer.contents in

  let+ result =
    Grpc_lwt.Client.call ~service:"qdrant.Qdrant" ~rpc:"HealthCheck"
      ~do_request:(H2_lwt_unix.Client.request connection ~error_handler:ignore)
      ~handler:
        (Grpc_lwt.Client.Rpc.unary enc ~f:(fun decoder ->
             let+ decoder = decoder in
             match decoder with
             | Some decoder -> (
                 Reader.create decoder |> decode |> function
                 | Ok v -> v
                 | Error e ->
                     failwith
                       (Printf.sprintf "Could not decode request: %s"
                          (Result.show_error e)))
             | None -> Proto.Qdrant.Qdrant.HealthCheckReply.make ()))
      ()
  in
  match result with Ok (x, _) -> Ok x | Error err -> Error err
