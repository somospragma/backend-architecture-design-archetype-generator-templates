package ${packageName};

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.testcontainers.containers.localstack.LocalStackContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;
import reactor.test.StepVerifier;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbAsyncClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.testcontainers.containers.localstack.LocalStackContainer.Service.DYNAMODB;

/**
 * Test for ${adapterName}DynamoDbAdapter using LocalStack
 */
@Testcontainers
class ${adapterName}DynamoDbAdapterTest {

    @Container
    static LocalStackContainer localstack = new LocalStackContainer(
            DockerImageName.parse("localstack/localstack:latest"))
            .withServices(DYNAMODB);

    private ${adapterName}DynamoDbAdapter adapter;
    private DynamoDbAsyncClient dynamoDbAsyncClient;
    private String tableName = "${adapterName?lower_case}_table";

    @BeforeEach
    void setUp() {
        dynamoDbAsyncClient = DynamoDbAsyncClient.builder()
                .endpointOverride(localstack.getEndpointOverride(DYNAMODB))
                .credentialsProvider(
                        StaticCredentialsProvider.create(
                                AwsBasicCredentials.create(
                                        localstack.getAccessKey(),
                                        localstack.getSecretKey()
                                )
                        )
                )
                .region(Region.of(localstack.getRegion()))
                .build();

        adapter = new ${adapterName}DynamoDbAdapter(dynamoDbAsyncClient);

        // Create table
        createTable();
    }

    private void createTable() {
        CreateTableRequest request = CreateTableRequest.builder()
                .tableName(tableName)
                .keySchema(
                        KeySchemaElement.builder()
                                .attributeName("id")
                                .keyType(KeyType.HASH)
                                .build()
                )
                .attributeDefinitions(
                        AttributeDefinition.builder()
                                .attributeName("id")
                                .attributeType(ScalarAttributeType.S)
                                .build()
                )
                .billingMode(BillingMode.PAY_PER_REQUEST)
                .build();

        dynamoDbAsyncClient.createTable(request).join();
    }

    @Test
    void testPutAndGetItem() {
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("id", AttributeValue.builder().s("test-id").build());
        item.put("name", AttributeValue.builder().s("Test Name").build());

        StepVerifier.create(adapter.putItem(item))
                .assertNext(response -> assertNotNull(response))
                .verifyComplete();

        Map<String, AttributeValue> key = new HashMap<>();
        key.put("id", AttributeValue.builder().s("test-id").build());

        StepVerifier.create(adapter.getItem(key))
                .assertNext(retrievedItem -> {
                    assertEquals("test-id", retrievedItem.get("id").s());
                    assertEquals("Test Name", retrievedItem.get("name").s());
                })
                .verifyComplete();
    }

    @Test
    void testDeleteItem() {
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("id", AttributeValue.builder().s("delete-id").build());
        item.put("name", AttributeValue.builder().s("To Delete").build());

        adapter.putItem(item).block();

        Map<String, AttributeValue> key = new HashMap<>();
        key.put("id", AttributeValue.builder().s("delete-id").build());

        StepVerifier.create(adapter.deleteItem(key))
                .assertNext(response -> assertNotNull(response))
                .verifyComplete();

        StepVerifier.create(adapter.getItem(key))
                .verifyComplete();
    }

    @Test
    void testScan() {
        Map<String, AttributeValue> item1 = new HashMap<>();
        item1.put("id", AttributeValue.builder().s("scan-1").build());
        item1.put("name", AttributeValue.builder().s("Item 1").build());

        Map<String, AttributeValue> item2 = new HashMap<>();
        item2.put("id", AttributeValue.builder().s("scan-2").build());
        item2.put("name", AttributeValue.builder().s("Item 2").build());

        adapter.putItem(item1).block();
        adapter.putItem(item2).block();

        StepVerifier.create(adapter.scan())
                .expectNextCount(2)
                .verifyComplete();
    }
}
