(lang dune 3.8)

(name qdrant)

(generate_opam_files true)

(source
 (github tmattio/qdrant))

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio <thibaut.mattio@gmail.com>")

(license ISC)

(documentation https://ocaml.org/p/qdrant)

(package
 (name qdrant)
 (synopsis "OCaml client for Qdrant vector search engine")
 (description "OCaml client for Qdrant vector search engine")
 (depends
  ocaml
  dune
  hyper
  pbrt
  grpc-lwt
  h2
  h2-lwt-unix
  (ocaml-protoc :build)))
