(************************************************)
(*       AUTOGENERATED FILE - DO NOT EDIT!      *)
(************************************************)
(* Generated by: ocaml-protoc-plugin            *)
(* https://github.com/issuu/ocaml-protoc-plugin *)
(************************************************)
(*
  Source: collections_service.proto
  Syntax: proto3
  Parameters:
    debug=false
    annot=''
    opens=[Google_types]
    int64_as_int=true
    int32_as_int=true
    fixed_as_int=false
    singleton_record=false
*)

open Ocaml_protoc_plugin.Runtime [@@warning "-33"]
open Google_types [@@warning "-33"]
(**/**)
module Imported'modules = struct
  module Collections = Collections
end
(**/**)
module Qdrant = struct
  module Collections = struct
    module Get = struct
      let name = "/qdrant.Collections/Get"
      module Request = Imported'modules.Collections.Qdrant.GetCollectionInfoRequest
      module Response = Imported'modules.Collections.Qdrant.GetCollectionInfoResponse
    end
    let get = 
      (module Imported'modules.Collections.Qdrant.GetCollectionInfoRequest : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.GetCollectionInfoRequest.t ), 
      (module Imported'modules.Collections.Qdrant.GetCollectionInfoResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.GetCollectionInfoResponse.t )
    
    module List = struct
      let name = "/qdrant.Collections/List"
      module Request = Imported'modules.Collections.Qdrant.ListCollectionsRequest
      module Response = Imported'modules.Collections.Qdrant.ListCollectionsResponse
    end
    let list = 
      (module Imported'modules.Collections.Qdrant.ListCollectionsRequest : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.ListCollectionsRequest.t ), 
      (module Imported'modules.Collections.Qdrant.ListCollectionsResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.ListCollectionsResponse.t )
    
    module Create = struct
      let name = "/qdrant.Collections/Create"
      module Request = Imported'modules.Collections.Qdrant.CreateCollection
      module Response = Imported'modules.Collections.Qdrant.CollectionOperationResponse
    end
    let create = 
      (module Imported'modules.Collections.Qdrant.CreateCollection : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.CreateCollection.t ), 
      (module Imported'modules.Collections.Qdrant.CollectionOperationResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.CollectionOperationResponse.t )
    
    module Update = struct
      let name = "/qdrant.Collections/Update"
      module Request = Imported'modules.Collections.Qdrant.UpdateCollection
      module Response = Imported'modules.Collections.Qdrant.CollectionOperationResponse
    end
    let update = 
      (module Imported'modules.Collections.Qdrant.UpdateCollection : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.UpdateCollection.t ), 
      (module Imported'modules.Collections.Qdrant.CollectionOperationResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.CollectionOperationResponse.t )
    
    module Delete = struct
      let name = "/qdrant.Collections/Delete"
      module Request = Imported'modules.Collections.Qdrant.DeleteCollection
      module Response = Imported'modules.Collections.Qdrant.CollectionOperationResponse
    end
    let delete = 
      (module Imported'modules.Collections.Qdrant.DeleteCollection : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.DeleteCollection.t ), 
      (module Imported'modules.Collections.Qdrant.CollectionOperationResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.CollectionOperationResponse.t )
    
    module UpdateAliases = struct
      let name = "/qdrant.Collections/UpdateAliases"
      module Request = Imported'modules.Collections.Qdrant.ChangeAliases
      module Response = Imported'modules.Collections.Qdrant.CollectionOperationResponse
    end
    let updateAliases = 
      (module Imported'modules.Collections.Qdrant.ChangeAliases : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.ChangeAliases.t ), 
      (module Imported'modules.Collections.Qdrant.CollectionOperationResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.CollectionOperationResponse.t )
    
    module ListCollectionAliases = struct
      let name = "/qdrant.Collections/ListCollectionAliases"
      module Request = Imported'modules.Collections.Qdrant.ListCollectionAliasesRequest
      module Response = Imported'modules.Collections.Qdrant.ListAliasesResponse
    end
    let listCollectionAliases = 
      (module Imported'modules.Collections.Qdrant.ListCollectionAliasesRequest : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.ListCollectionAliasesRequest.t ), 
      (module Imported'modules.Collections.Qdrant.ListAliasesResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.ListAliasesResponse.t )
    
    module ListAliases = struct
      let name = "/qdrant.Collections/ListAliases"
      module Request = Imported'modules.Collections.Qdrant.ListAliasesRequest
      module Response = Imported'modules.Collections.Qdrant.ListAliasesResponse
    end
    let listAliases = 
      (module Imported'modules.Collections.Qdrant.ListAliasesRequest : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.ListAliasesRequest.t ), 
      (module Imported'modules.Collections.Qdrant.ListAliasesResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.ListAliasesResponse.t )
    
    module CollectionClusterInfo = struct
      let name = "/qdrant.Collections/CollectionClusterInfo"
      module Request = Imported'modules.Collections.Qdrant.CollectionClusterInfoRequest
      module Response = Imported'modules.Collections.Qdrant.CollectionClusterInfoResponse
    end
    let collectionClusterInfo = 
      (module Imported'modules.Collections.Qdrant.CollectionClusterInfoRequest : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.CollectionClusterInfoRequest.t ), 
      (module Imported'modules.Collections.Qdrant.CollectionClusterInfoResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.CollectionClusterInfoResponse.t )
    
    module UpdateCollectionClusterSetup = struct
      let name = "/qdrant.Collections/UpdateCollectionClusterSetup"
      module Request = Imported'modules.Collections.Qdrant.UpdateCollectionClusterSetupRequest
      module Response = Imported'modules.Collections.Qdrant.UpdateCollectionClusterSetupResponse
    end
    let updateCollectionClusterSetup = 
      (module Imported'modules.Collections.Qdrant.UpdateCollectionClusterSetupRequest : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.UpdateCollectionClusterSetupRequest.t ), 
      (module Imported'modules.Collections.Qdrant.UpdateCollectionClusterSetupResponse : Runtime'.Service.Message with type t = Imported'modules.Collections.Qdrant.UpdateCollectionClusterSetupResponse.t )
    
  end
end