# ocaml-qdrant

OCaml client for Qdrant vector search engine.

## Usage

```
# With env variable
docker run -p 6333:6333 -p 6334:6334 \
    -e QDRANT__SERVICE__GRPC_PORT="6334" \
    qdrant/qdrant
```

```ocaml
let main () =
  let open Lwt.Syntax in
  let+ result = Qdrant.health_check Qdrant.default_client in
  match result with
  | Ok Qdrant.{ title; version } ->
      Printf.printf "Got title:%S version:%S\n" title version
  | Error _ -> Printf.eprintf "Oops, an error occured\n"

let () = Lwt_main.run (main ())
```

## License

Yoshi is released under the ISC License. See the LICENSE file for more details.
