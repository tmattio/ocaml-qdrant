let main () =
  let open Lwt.Syntax in
  let* _result =
    Qdrant.delete_collection ~collection_name:"test" Qdrant.default_client
  in
  let* _result =
    let vectors_config =
      `Params
        Qdrant.
          {
            size = 10;
            distance = Cosine;
            hnsw_config = None;
            quantization_config = None;
            on_disk = None;
          }
    in
    Qdrant.create_collection ~collection_name:"test" ~vectors_config
      Qdrant.default_client
  in
  let+ result = Qdrant.list_collections Qdrant.default_client in
  match result with
  | Ok collections -> List.iter (Printf.printf "%s ") collections
  | Error _ -> Printf.eprintf "Oops, an error occured\n"

let () = Lwt_main.run (main ())
