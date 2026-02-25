package ${packageName}.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.sqs.SqsClient;

import java.net.URI;

/**
 * SQS configuration for ${adapterName}.
 * Configures synchronous SqsClient.
 */
@Configuration
public class ${adapterName}SqsConfig {

    @Value("${'${aws.sqs.endpoint:}")
    private String endpoint;

    @Value("${'${aws.sqs.region:us-east-1}")
    private String region;

    @Value("${'${aws.sqs.access-key:}")
    private String accessKey;

    @Value("${'${aws.sqs.secret-key:}")
    private String secretKey;

    @Bean
    public SqsClient sqsClient() {
        var builder = SqsClient.builder()
                .region(Region.of(region));

        // Configure credentials if provided
        if (accessKey != null && !accessKey.isEmpty() && secretKey != null && !secretKey.isEmpty()) {
            builder.credentialsProvider(
                    StaticCredentialsProvider.create(
                            AwsBasicCredentials.create(accessKey, secretKey)
                    )
            );
        }

        // Configure endpoint if provided (for LocalStack)
        if (endpoint != null && !endpoint.isEmpty()) {
            builder.endpointOverride(URI.create(endpoint));
        }

        return builder.build();
    }
}
