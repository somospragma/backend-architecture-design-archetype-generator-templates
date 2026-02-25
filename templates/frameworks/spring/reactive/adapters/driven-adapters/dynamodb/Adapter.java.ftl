package ${packageName};

import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import software.amazon.awssdk.services.dynamodb.DynamoDbAsyncClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.util.Map;

/**
 * DynamoDB adapter for ${adapterName}.
 * Implements DynamoDB operations using DynamoDbAsyncClient.
 */
@Component
public class ${adapterName}DynamoDbAdapter {

    private final DynamoDbAsyncClient dynamoDbAsyncClient;
    private final String tableName;

    public ${adapterName}DynamoDbAdapter(DynamoDbAsyncClient dynamoDbAsyncClient) {
        this.dynamoDbAsyncClient = dynamoDbAsyncClient;
        this.tableName = "${adapterName?lower_case}_table";
    }

    /**
     * Puts an item into DynamoDB table.
     */
    public Mono<PutItemResponse> putItem(Map<String, AttributeValue> item) {
        PutItemRequest request = PutItemRequest.builder()
                .tableName(tableName)
                .item(item)
                .build();

        return Mono.fromCompletionStage(dynamoDbAsyncClient.putItem(request));
    }

    /**
     * Gets an item from DynamoDB table by key.
     */
    public Mono<Map<String, AttributeValue>> getItem(Map<String, AttributeValue> key) {
        GetItemRequest request = GetItemRequest.builder()
                .tableName(tableName)
                .key(key)
                .build();

        return Mono.fromCompletionStage(dynamoDbAsyncClient.getItem(request))
                .map(GetItemResponse::item)
                .filter(item -> !item.isEmpty());
    }

    /**
     * Updates an item in DynamoDB table.
     */
    public Mono<UpdateItemResponse> updateItem(
            Map<String, AttributeValue> key,
            Map<String, AttributeValueUpdate> updates) {
        UpdateItemRequest request = UpdateItemRequest.builder()
                .tableName(tableName)
                .key(key)
                .attributeUpdates(updates)
                .build();

        return Mono.fromCompletionStage(dynamoDbAsyncClient.updateItem(request));
    }

    /**
     * Deletes an item from DynamoDB table.
     */
    public Mono<DeleteItemResponse> deleteItem(Map<String, AttributeValue> key) {
        DeleteItemRequest request = DeleteItemRequest.builder()
                .tableName(tableName)
                .key(key)
                .build();

        return Mono.fromCompletionStage(dynamoDbAsyncClient.deleteItem(request));
    }

    /**
     * Scans the DynamoDB table.
     */
    public Flux<Map<String, AttributeValue>> scan() {
        ScanRequest request = ScanRequest.builder()
                .tableName(tableName)
                .build();

        return Mono.fromCompletionStage(dynamoDbAsyncClient.scan(request))
                .flatMapMany(response -> Flux.fromIterable(response.items()));
    }

    /**
     * Queries the DynamoDB table with a key condition.
     */
    public Flux<Map<String, AttributeValue>> query(String keyConditionExpression,
                                                     Map<String, AttributeValue> expressionAttributeValues) {
        QueryRequest request = QueryRequest.builder()
                .tableName(tableName)
                .keyConditionExpression(keyConditionExpression)
                .expressionAttributeValues(expressionAttributeValues)
                .build();

        return Mono.fromCompletionStage(dynamoDbAsyncClient.query(request))
                .flatMapMany(response -> Flux.fromIterable(response.items()));
    }
}
