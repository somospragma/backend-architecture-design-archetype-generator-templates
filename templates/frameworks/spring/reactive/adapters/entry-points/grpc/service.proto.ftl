syntax = "proto3";

option java_multiple_files = true;
option java_package = "${packageName}.proto";
option java_outer_classname = "${adapterName}ServiceProto";

package ${adapterName?lower_case};

// ${adapterName} gRPC Service
service ${adapterName}Service {
  // Unary RPC: Get a single item
  rpc GetItem (GetItemRequest) returns (ItemResponse);

  // Server streaming RPC: Get all items as a stream
  rpc GetAllItems (GetAllItemsRequest) returns (stream ItemResponse);

  // Client streaming RPC: Create multiple items
  rpc CreateItems (stream CreateItemRequest) returns (CreateItemsResponse);

  // Bidirectional streaming RPC: Process items in real-time
  rpc ProcessItems (stream ProcessItemRequest) returns (stream ItemResponse);

  // Unary RPC: Update an item
  rpc UpdateItem (UpdateItemRequest) returns (ItemResponse);

  // Unary RPC: Delete an item
  rpc DeleteItem (DeleteItemRequest) returns (DeleteItemResponse);
}

// Request message for getting a single item
message GetItemRequest {
  string id = 1;
}

// Request message for getting all items
message GetAllItemsRequest {
  int32 limit = 1;
  int32 offset = 2;
}

// Request message for creating an item
message CreateItemRequest {
  string name = 1;
}

// Response message for creating multiple items
message CreateItemsResponse {
  int32 count = 1;
  repeated string ids = 2;
}

// Request message for processing items
message ProcessItemRequest {
  string id = 1;
  string action = 2;
}

// Request message for updating an item
message UpdateItemRequest {
  string id = 1;
  string name = 2;
}

// Request message for deleting an item
message DeleteItemRequest {
  string id = 1;
}

// Response message for delete operation
message DeleteItemResponse {
  bool success = 1;
}

// Response message for item operations
message ItemResponse {
  string id = 1;
  string name = 2;
}
