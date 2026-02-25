package ${packageName};

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.client.inject.GrpcClient;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;

import ${packageName}.proto.*;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Test for ${adapterName}GrpcService using blocking stub
 */
@SpringBootTest(properties = {
        "grpc.server.port=9091",
        "grpc.server.in-process-name=test"
})
@DirtiesContext
class ${adapterName}GrpcServiceTest {

    @GrpcClient("inProcess")
    private ${adapterName}ServiceGrpc.${adapterName}ServiceBlockingStub blockingStub;

    @GrpcClient("inProcess")
    private ${adapterName}ServiceGrpc.${adapterName}ServiceStub asyncStub;

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

        ItemResponse response = blockingStub.getItem(request);

        assertThat(response.getId()).isEqualTo("123");
        assertThat(response.getName()).isNotNull();
    }

    @Test
    void testGetAllItems() throws InterruptedException {
        GetAllItemsRequest request = GetAllItemsRequest.newBuilder()
                .setLimit(5)
                .setOffset(0)
                .build();

        List<ItemResponse> responses = new ArrayList<>();
        CountDownLatch latch = new CountDownLatch(1);

        asyncStub.getAllItems(request, new StreamObserver<ItemResponse>() {
            @Override
            public void onNext(ItemResponse value) {
                responses.add(value);
            }

            @Override
            public void onError(Throwable t) {
                latch.countDown();
            }

            @Override
            public void onCompleted() {
                latch.countDown();
            }
        });

        assertTrue(latch.await(5, TimeUnit.SECONDS));
        assertThat(responses).hasSize(5);
    }

    @Test
    void testCreateItems() throws InterruptedException {
        CountDownLatch latch = new CountDownLatch(1);
        List<CreateItemsResponse> responses = new ArrayList<>();

        StreamObserver<CreateItemRequest> requestObserver = asyncStub.createItems(
                new StreamObserver<CreateItemsResponse>() {
                    @Override
                    public void onNext(CreateItemsResponse value) {
                        responses.add(value);
                    }

                    @Override
                    public void onError(Throwable t) {
                        latch.countDown();
                    }

                    @Override
                    public void onCompleted() {
                        latch.countDown();
                    }
                });

        requestObserver.onNext(CreateItemRequest.newBuilder().setName("Item 1").build());
        requestObserver.onNext(CreateItemRequest.newBuilder().setName("Item 2").build());
        requestObserver.onNext(CreateItemRequest.newBuilder().setName("Item 3").build());
        requestObserver.onCompleted();

        assertTrue(latch.await(5, TimeUnit.SECONDS));
        assertThat(responses).hasSize(1);
        assertThat(responses.get(0).getCount()).isEqualTo(3);
        assertThat(responses.get(0).getIdsCount()).isEqualTo(3);
    }

    @Test
    void testProcessItems() throws InterruptedException {
        CountDownLatch latch = new CountDownLatch(1);
        List<ItemResponse> responses = new ArrayList<>();

        StreamObserver<ProcessItemRequest> requestObserver = asyncStub.processItems(
                new StreamObserver<ItemResponse>() {
                    @Override
                    public void onNext(ItemResponse value) {
                        responses.add(value);
                    }

                    @Override
                    public void onError(Throwable t) {
                        latch.countDown();
                    }

                    @Override
                    public void onCompleted() {
                        latch.countDown();
                    }
                });

        requestObserver.onNext(ProcessItemRequest.newBuilder()
                .setId("1")
                .setAction("process")
                .build());
        requestObserver.onNext(ProcessItemRequest.newBuilder()
                .setId("2")
                .setAction("validate")
                .build());
        requestObserver.onCompleted();

        assertTrue(latch.await(5, TimeUnit.SECONDS));
        assertThat(responses).hasSize(2);
    }

    @Test
    void testUpdateItem() {
        UpdateItemRequest request = UpdateItemRequest.newBuilder()
                .setId("123")
                .setName("Updated Item")
                .build();

        ItemResponse response = blockingStub.updateItem(request);

        assertThat(response.getId()).isEqualTo("123");
        assertThat(response.getName()).isEqualTo("Updated Item");
    }

    @Test
    void testDeleteItem() {
        DeleteItemRequest request = DeleteItemRequest.newBuilder()
                .setId("123")
                .build();

        DeleteItemResponse response = blockingStub.deleteItem(request);

        assertThat(response.getSuccess()).isTrue();
    }
}
