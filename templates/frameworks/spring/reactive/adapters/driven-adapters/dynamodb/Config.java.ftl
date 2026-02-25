package ${packageName}.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbAsyncClient;

import java.net.URI;

/**
 * DynamoDB configuration for ${adapterName}.
 */
@Configuration
public class ${adapterName}DynamoDbConfig {

    @Value("${'${aws.dynamodb.endpoint:}")
    private String endpoint;

    @Value("${'${aws.dynamodb.region:us-east-1}")
    private String region;

    @Value("${'${aws.dynamodb.access-key:}")
    private String accessKey;

    @Value("${'${aws.dynamodb.secret-key:}")
    private String secretKey;

    @Bean
    public DynamoDbAsyncClient dynamoDbAsyncClient() {
        var builder = DynamoDbAsyncClient.builder()
                .region(Region.of(region));

        // Configure credentials if provided
        if (accessKey != null && !accessKey.isEmpty() && secretKey != null && !secretKey.isEmpty()) {
            builder.credentialsProvider(
                    StaticCredentialsProvider.create(
                            AwsBasicCredentials.create(accessKey, secretKey)
                    )
            );
        }

        // Configure endpoint if provided (for LocalStack or DynamoDB Local)
        if (endpoint != null && !endpoint.isEmpty()) {
            builder.endpointOverride(URI.create(endpoint));
        }

        return builder.build();
    }
}
