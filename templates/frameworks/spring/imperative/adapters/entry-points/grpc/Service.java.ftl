package ${packageName};

import io.grpc.Status;
import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.server.service.GrpcService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ${packageName}.proto.*;

import java.util.ArrayList;
import java.util.List;

/**
 * gRPC Service implementation for ${adapterName}.
 * Implements synchronous gRPC operations using BlockingStub pattern.
 */
@GrpcService
public class ${adapterName}GrpcService extends ${adapterName}ServiceGrpc.${adapterName}ServiceImplBase {

    private static final Logger logger = LoggerFactory.getLogger(${adapterName}GrpcService.class);

    /**
     * Unary RPC: Get a single item by ID.
     */
    @Override
    public void getItem(GetItemRequest request, StreamObserver<ItemResponse> responseObserver) {
        try {
            logger.info("Getting item with id: {}", request.getId());
            
            // TODO: Implement your business logic here
            ItemResponse response = ItemResponse.newBuilder()
                    .setId(request.getId())
                    .setName("Sample Item")
                    .build();
            
            responseObserver.onNext(response);
            responseObserver.onCompleted();
        } catch (Exception e) {
            logger.error("Error getting item", e);
            responseObserver.onError(Status.INTERNAL
                    .withDescription("Error getting item: " + e.getMessage())
                    .asRuntimeException());
        }
    }

    /**
     * Server streaming RPC: Get all items as a stream.
     */
    @Override
    public void getAllItems(GetAllItemsRequest request, StreamObserver<ItemResponse> responseObserver) {
        try {
            logger.info("Getting all items with limit: {}, offset: {}", 
                    request.getLimit(), request.getOffset());
            
            // TODO: Implement your business logic here
            int limit = request.getLimit() > 0 ? request.getLimit() : 10;
            
            for (int i = 1; i <= limit; i++) {
                ItemResponse response = ItemResponse.newBuilder()
                        .setId(String.valueOf(i))
                        .setName("Item " + i)
                        .build();
                
                responseObserver.onNext(response);
            }
            
            responseObserver.onCompleted();
        } catch (Exception e) {
            logger.error("Error getting all items", e);
            responseObserver.onError(Status.INTERNAL
                    .withDescription("Error getting all items: " + e.getMessage())
                    .asRuntimeException());
        }
    }

    /**
     * Client streaming RPC: Create multiple items from a stream.
     */
    @Override
    public StreamObserver<CreateItemRequest> createItems(StreamObserver<CreateItemsResponse> responseObserver) {
        return new StreamObserver<CreateItemRequest>() {
            private final List<String> ids = new ArrayList<>();

            @Override
            public void onNext(CreateItemRequest request) {
                logger.info("Creating item: {}", request.getName());
                // TODO: Implement your business logic here
                ids.add("id-" + request.getName());
            }

            @Override
            public void onError(Throwable t) {
                logger.error("Error creating items", t);
                responseObserver.onError(Status.INTERNAL
                        .withDescription("Error creating items: " + t.getMessage())
                        .asRuntimeException());
            }

            @Override
            public void onCompleted() {
                CreateItemsResponse response = CreateItemsResponse.newBuilder()
                        .setCount(ids.size())
                        .addAllIds(ids)
                        .build();
                
                responseObserver.onNext(response);
                responseObserver.onCompleted();
            }
        };
    }

    /**
     * Bidirectional streaming RPC: Process items in real-time.
     */
    @Override
    public StreamObserver<ProcessItemRequest> processItems(StreamObserver<ItemResponse> responseObserver) {
        return new StreamObserver<ProcessItemRequest>() {
            @Override
            public void onNext(ProcessItemRequest request) {
                try {
                    logger.info("Processing item: {} with action: {}", 
                            request.getId(), request.getAction());
                    
                    // TODO: Implement your business logic here
                    ItemResponse response = ItemResponse.newBuilder()
                            .setId(request.getId())
                            .setName("Processed: " + request.getAction())
                            .build();
                    
                    responseObserver.onNext(response);
                } catch (Exception e) {
                    logger.error("Error processing item", e);
                    responseObserver.onError(Status.INTERNAL
                            .withDescription("Error processing item: " + e.getMessage())
                            .asRuntimeException());
                }
            }

            @Override
            public void onError(Throwable t) {
                logger.error("Error in process items stream", t);
                responseObserver.onError(Status.INTERNAL
                        .withDescription("Error processing items: " + t.getMessage())
                        .asRuntimeException());
            }

            @Override
            public void onCompleted() {
                responseObserver.onCompleted();
            }
        };
    }

    /**
     * Unary RPC: Update an item.
     */
    @Override
    public void updateItem(UpdateItemRequest request, StreamObserver<ItemResponse> responseObserver) {
        try {
            logger.info("Updating item: {} with name: {}", request.getId(), request.getName());
            
            // TODO: Implement your business logic here
            ItemResponse response = ItemResponse.newBuilder()
                    .setId(request.getId())
                    .setName(request.getName())
                    .build();
            
            responseObserver.onNext(response);
            responseObserver.onCompleted();
        } catch (Exception e) {
            logger.error("Error updating item", e);
            responseObserver.onError(Status.INTERNAL
                    .withDescription("Error updating item: " + e.getMessage())
                    .asRuntimeException());
        }
    }

    /**
     * Unary RPC: Delete an item.
     */
    @Override
    public void deleteItem(DeleteItemRequest request, StreamObserver<DeleteItemResponse> responseObserver) {
        try {
            logger.info("Deleting item: {}", request.getId());
            
            // TODO: Implement your business logic here
            DeleteItemResponse response = DeleteItemResponse.newBuilder()
                    .setSuccess(true)
                    .build();
            
            responseObserver.onNext(response);
            responseObserver.onCompleted();
        } catch (Exception e) {
            logger.error("Error deleting item", e);
            responseObserver.onError(Status.INTERNAL
                    .withDescription("Error deleting item: " + e.getMessage())
                    .asRuntimeException());
        }
    }
}
