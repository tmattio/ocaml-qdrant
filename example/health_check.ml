let main () =
  let open Lwt.Syntax in
  let+ result = Qdrant.health_check Qdrant.default_client in
  match result with
  | Ok Qdrant.{ title; version } ->
      Printf.printf "Got title:%S version:%S\n" title version
  | Error _ -> Printf.eprintf "Oops, an error occured\n"

let () = Lwt_main.run (main ())
