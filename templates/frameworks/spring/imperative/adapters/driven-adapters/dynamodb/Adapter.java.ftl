package ${packageName};

import org.springframework.stereotype.Component;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * DynamoDB adapter for ${adapterName}.
 * Implements DynamoDB operations using DynamoDbClient (synchronous).
 */
@Component
public class ${adapterName}DynamoDbAdapter {

    private final DynamoDbClient dynamoDbClient;
    private final String tableName;

    public ${adapterName}DynamoDbAdapter(DynamoDbClient dynamoDbClient) {
        this.dynamoDbClient = dynamoDbClient;
        this.tableName = "${adapterName?lower_case}_table";
    }

    /**
     * Puts an item into DynamoDB table.
     */
    public PutItemResponse putItem(Map<String, AttributeValue> item) {
        PutItemRequest request = PutItemRequest.builder()
                .tableName(tableName)
                .item(item)
                .build();

        return dynamoDbClient.putItem(request);
    }

    /**
     * Gets an item from DynamoDB table by key.
     */
    public Optional<Map<String, AttributeValue>> getItem(Map<String, AttributeValue> key) {
        GetItemRequest request = GetItemRequest.builder()
                .tableName(tableName)
                .key(key)
                .build();

        GetItemResponse response = dynamoDbClient.getItem(request);
        
        if (response.item() == null || response.item().isEmpty()) {
            return Optional.empty();
        }
        
        return Optional.of(response.item());
    }

    /**
     * Updates an item in DynamoDB table.
     */
    public UpdateItemResponse updateItem(
            Map<String, AttributeValue> key,
            Map<String, AttributeValueUpdate> updates) {
        UpdateItemRequest request = UpdateItemRequest.builder()
                .tableName(tableName)
                .key(key)
                .attributeUpdates(updates)
                .build();

        return dynamoDbClient.updateItem(request);
    }

    /**
     * Deletes an item from DynamoDB table.
     */
    public DeleteItemResponse deleteItem(Map<String, AttributeValue> key) {
        DeleteItemRequest request = DeleteItemRequest.builder()
                .tableName(tableName)
                .key(key)
                .build();

        return dynamoDbClient.deleteItem(request);
    }

    /**
     * Scans the DynamoDB table.
     */
    public List<Map<String, AttributeValue>> scan() {
        ScanRequest request = ScanRequest.builder()
                .tableName(tableName)
                .build();

        ScanResponse response = dynamoDbClient.scan(request);
        return response.items();
    }

    /**
     * Queries the DynamoDB table with a key condition.
     */
    public List<Map<String, AttributeValue>> query(
            String keyConditionExpression,
            Map<String, AttributeValue> expressionAttributeValues) {
        QueryRequest request = QueryRequest.builder()
                .tableName(tableName)
                .keyConditionExpression(keyConditionExpression)
                .expressionAttributeValues(expressionAttributeValues)
                .build();

        QueryResponse response = dynamoDbClient.query(request);
        return response.items();
    }
}
