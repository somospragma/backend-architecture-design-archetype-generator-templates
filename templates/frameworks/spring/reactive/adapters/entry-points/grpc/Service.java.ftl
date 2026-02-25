package ${packageName};

import com.salesforce.reactorgrpc.GrpcRetry;
import io.grpc.Status;
import net.devh.boot.grpc.server.service.GrpcService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import ${packageName}.proto.*;

import java.time.Duration;

/**
 * gRPC Service implementation for ${adapterName}.
 * Implements reactive gRPC operations using Reactor.
 */
@GrpcService
public class ${adapterName}GrpcService extends Reactor${adapterName}ServiceGrpc.${adapterName}ServiceImplBase {

    private static final Logger logger = LoggerFactory.getLogger(${adapterName}GrpcService.class);

    /**
     * Unary RPC: Get a single item by ID.
     */
    @Override
    public Mono<ItemResponse> getItem(Mono<GetItemRequest> request) {
        return request
                .doOnNext(req -> logger.info("Getting item with id: {}", req.getId()))
                .flatMap(req -> {
                    // TODO: Implement your business logic here
                    return Mono.just(ItemResponse.newBuilder()
                            .setId(req.getId())
                            .setName("Sample Item")
                            .build());
                })
                .doOnError(error -> logger.error("Error getting item", error))
                .onErrorResume(error -> Mono.error(
                        Status.INTERNAL
                                .withDescription("Error getting item: " + error.getMessage())
                                .asRuntimeException()
                ));
    }

    /**
     * Server streaming RPC: Get all items as a stream.
     */
    @Override
    public Flux<ItemResponse> getAllItems(Mono<GetAllItemsRequest> request) {
        return request
                .doOnNext(req -> logger.info("Getting all items with limit: {}, offset: {}", 
                        req.getLimit(), req.getOffset()))
                .flatMapMany(req -> {
                    // TODO: Implement your business logic here
                    int limit = req.getLimit() > 0 ? req.getLimit() : 10;
                    return Flux.range(1, limit)
                            .map(i -> ItemResponse.newBuilder()
                                    .setId(String.valueOf(i))
                                    .setName("Item " + i)
                                    .build())
                            .delayElements(Duration.ofMillis(100));
                })
                .doOnError(error -> logger.error("Error getting all items", error))
                .onErrorResume(error -> Flux.error(
                        Status.INTERNAL
                                .withDescription("Error getting all items: " + error.getMessage())
                                .asRuntimeException()
                ));
    }

    /**
     * Client streaming RPC: Create multiple items from a stream.
     */
    @Override
    public Mono<CreateItemsResponse> createItems(Flux<CreateItemRequest> request) {
        return request
                .doOnNext(req -> logger.info("Creating item: {}", req.getName()))
                .collectList()
                .flatMap(items -> {
                    // TODO: Implement your business logic here
                    return Mono.just(CreateItemsResponse.newBuilder()
                            .setCount(items.size())
                            .addAllIds(items.stream()
                                    .map(item -> "id-" + item.getName())
                                    .toList())
                            .build());
                })
                .doOnError(error -> logger.error("Error creating items", error))
                .onErrorResume(error -> Mono.error(
                        Status.INTERNAL
                                .withDescription("Error creating items: " + error.getMessage())
                                .asRuntimeException()
                ));
    }

    /**
     * Bidirectional streaming RPC: Process items in real-time.
     */
    @Override
    public Flux<ItemResponse> processItems(Flux<ProcessItemRequest> request) {
        return request
                .doOnNext(req -> logger.info("Processing item: {} with action: {}", 
                        req.getId(), req.getAction()))
                .flatMap(req -> {
                    // TODO: Implement your business logic here
                    return Mono.just(ItemResponse.newBuilder()
                            .setId(req.getId())
                            .setName("Processed: " + req.getAction())
                            .build());
                })
                .doOnError(error -> logger.error("Error processing items", error))
                .onErrorResume(error -> Flux.error(
                        Status.INTERNAL
                                .withDescription("Error processing items: " + error.getMessage())
                                .asRuntimeException()
                ));
    }

    /**
     * Unary RPC: Update an item.
     */
    @Override
    public Mono<ItemResponse> updateItem(Mono<UpdateItemRequest> request) {
        return request
                .doOnNext(req -> logger.info("Updating item: {} with name: {}", 
                        req.getId(), req.getName()))
                .flatMap(req -> {
                    // TODO: Implement your business logic here
                    return Mono.just(ItemResponse.newBuilder()
                            .setId(req.getId())
                            .setName(req.getName())
                            .build());
                })
                .doOnError(error -> logger.error("Error updating item", error))
                .onErrorResume(error -> Mono.error(
                        Status.INTERNAL
                                .withDescription("Error updating item: " + error.getMessage())
                                .asRuntimeException()
                ));
    }

    /**
     * Unary RPC: Delete an item.
     */
    @Override
    public Mono<DeleteItemResponse> deleteItem(Mono<DeleteItemRequest> request) {
        return request
                .doOnNext(req -> logger.info("Deleting item: {}", req.getId()))
                .flatMap(req -> {
                    // TODO: Implement your business logic here
                    return Mono.just(DeleteItemResponse.newBuilder()
                            .setSuccess(true)
                            .build());
                })
                .doOnError(error -> logger.error("Error deleting item", error))
                .onErrorResume(error -> Mono.error(
                        Status.INTERNAL
                                .withDescription("Error deleting item: " + error.getMessage())
                                .asRuntimeException()
                ));
    }
}
