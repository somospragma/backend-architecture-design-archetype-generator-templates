package ${packageName};

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.testcontainers.containers.localstack.LocalStackContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
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
    private DynamoDbClient dynamoDbClient;
    private String tableName = "${adapterName?lower_case}_table";

    @BeforeEach
    void setUp() {
        dynamoDbClient = DynamoDbClient.builder()
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

        adapter = new ${adapterName}DynamoDbAdapter(dynamoDbClient);

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

        dynamoDbClient.createTable(request);
    }

    @Test
    void testPutAndGetItem() {
        // Given
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("id", AttributeValue.builder().s("test-id").build());
        item.put("name", AttributeValue.builder().s("Test Name").build());

        // When
        PutItemResponse putResponse = adapter.putItem(item);
        
        // Then
        assertThat(putResponse).isNotNull();

        Map<String, AttributeValue> key = new HashMap<>();
        key.put("id", AttributeValue.builder().s("test-id").build());

        Optional<Map<String, AttributeValue>> retrievedItem = adapter.getItem(key);
        
        assertThat(retrievedItem).isPresent();
        assertThat(retrievedItem.get().get("id").s()).isEqualTo("test-id");
        assertThat(retrievedItem.get().get("name").s()).isEqualTo("Test Name");
    }

    @Test
    void testGetItem_notFound() {
        // Given
        Map<String, AttributeValue> key = new HashMap<>();
        key.put("id", AttributeValue.builder().s("non-existent").build());

        // When
        Optional<Map<String, AttributeValue>> result = adapter.getItem(key);

        // Then
        assertThat(result).isEmpty();
    }

    @Test
    void testDeleteItem() {
        // Given
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("id", AttributeValue.builder().s("delete-id").build());
        item.put("name", AttributeValue.builder().s("To Delete").build());

        adapter.putItem(item);

        Map<String, AttributeValue> key = new HashMap<>();
        key.put("id", AttributeValue.builder().s("delete-id").build());

        // When
        DeleteItemResponse deleteResponse = adapter.deleteItem(key);

        // Then
        assertThat(deleteResponse).isNotNull();
        
        Optional<Map<String, AttributeValue>> result = adapter.getItem(key);
        assertThat(result).isEmpty();
    }

    @Test
    void testScan() {
        // Given
        Map<String, AttributeValue> item1 = new HashMap<>();
        item1.put("id", AttributeValue.builder().s("scan-1").build());
        item1.put("name", AttributeValue.builder().s("Item 1").build());

        Map<String, AttributeValue> item2 = new HashMap<>();
        item2.put("id", AttributeValue.builder().s("scan-2").build());
        item2.put("name", AttributeValue.builder().s("Item 2").build());

        adapter.putItem(item1);
        adapter.putItem(item2);

        // When
        List<Map<String, AttributeValue>> items = adapter.scan();

        // Then
        assertThat(items).hasSizeGreaterThanOrEqualTo(2);
    }
}
