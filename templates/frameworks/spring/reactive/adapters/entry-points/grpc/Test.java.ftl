package ${packageName};

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import net.devh.boot.grpc.client.inject.GrpcClient;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import ${packageName}.proto.*;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test for ${adapterName}GrpcService
 */
@SpringBootTest(properties = {
        "grpc.server.port=9091",
        "grpc.server.in-process-name=test"
})
@DirtiesContext
class ${adapterName}GrpcServiceTest {

    @GrpcClient("inProcess")
    private Reactor${adapterName}ServiceGrpc.Reactor${adapterName}ServiceStub reactiveStub;

    private ManagedChannel channel;

    @BeforeEach
    void setUp() {
        channel = ManagedChannelBuilder.forAddress("localhost", 9091)
                .usePlaintext()
                .build();
    }

    @AfterEach
    void tearDown() {
        if (channel != null && !channel.isShutdown()) {
            channel.shutdown();
        }
    }

    @Test
    void testGetItem() {
        GetItemRequest request = GetItemRequest.newBuilder()
                .setId("123")
                .build();

        Mono<ItemResponse> response = reactiveStub.getItem(Mono.just(request));

        StepVerifier.create(response)
                .assertNext(item -> {
                    assertEquals("123", item.getId());
                    assertNotNull(item.getName());
                })
                .verifyComplete();
    }

    @Test
    void testGetAllItems() {
        GetAllItemsRequest request = GetAllItemsRequest.newBuilder()
                .setLimit(5)
                .setOffset(0)
                .build();

        Flux<ItemResponse> response = reactiveStub.getAllItems(Mono.just(request));

        StepVerifier.create(response)
                .expectNextCount(5)
                .verifyComplete();
    }

    @Test
    void testCreateItems() {
        Flux<CreateItemRequest> requests = Flux.just(
                CreateItemRequest.newBuilder().setName("Item 1").build(),
                CreateItemRequest.newBuilder().setName("Item 2").build(),
                CreateItemRequest.newBuilder().setName("Item 3").build()
        );

        Mono<CreateItemsResponse> response = reactiveStub.createItems(requests);

        StepVerifier.create(response)
                .assertNext(result -> {
                    assertEquals(3, result.getCount());
                    assertEquals(3, result.getIdsCount());
                })
                .verifyComplete();
    }

    @Test
    void testProcessItems() {
        Flux<ProcessItemRequest> requests = Flux.just(
                ProcessItemRequest.newBuilder()
                        .setId("1")
                        .setAction("process")
                        .build(),
                ProcessItemRequest.newBuilder()
                        .setId("2")
                        .setAction("validate")
                        .build()
        );

        Flux<ItemResponse> response = reactiveStub.processItems(requests);

        StepVerifier.create(response)
                .expectNextCount(2)
                .verifyComplete();
    }

    @Test
    void testUpdateItem() {
        UpdateItemRequest request = UpdateItemRequest.newBuilder()
                .setId("123")
                .setName("Updated Item")
                .build();

        Mono<ItemResponse> response = reactiveStub.updateItem(Mono.just(request));

        StepVerifier.create(response)
                .assertNext(item -> {
                    assertEquals("123", item.getId());
                    assertEquals("Updated Item", item.getName());
                })
                .verifyComplete();
    }

    @Test
    void testDeleteItem() {
        DeleteItemRequest request = DeleteItemRequest.newBuilder()
                .setId("123")
                .build();

        Mono<DeleteItemResponse> response = reactiveStub.deleteItem(Mono.just(request));

        StepVerifier.create(response)
                .assertNext(result -> assertTrue(result.getSuccess()))
                .verifyComplete();
    }

    @Test
    void testGetAllItemsWithBackpressure() {
        GetAllItemsRequest request = GetAllItemsRequest.newBuilder()
                .setLimit(100)
                .build();

        Flux<ItemResponse> response = reactiveStub.getAllItems(Mono.just(request));

        StepVerifier.create(response, 10)
                .expectNextCount(10)
                .thenRequest(10)
                .expectNextCount(10)
                .thenCancel()
                .verify();
    }
}
