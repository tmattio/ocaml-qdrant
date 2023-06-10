type client = { host : string; port : int }

val default_client : client

type health_check = { title : string; version : string }

val health_check : client -> (health_check, Grpc.Status.t) result Lwt.t
