package ${packageName}.config;

import io.awspring.cloud.sqs.config.SqsMessageListenerContainerFactory;
import io.awspring.cloud.sqs.operations.SqsTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.sqs.SqsAsyncClient;

import java.net.URI;
import java.time.Duration;

/**
 * SQS Consumer configuration for ${adapterName}.
 */
@Configuration
public class ${adapterName}SqsConsumerConfig {

    @Value("${'${aws.sqs.consumer.endpoint:}")
    private String endpoint;

    @Value("${'${aws.sqs.consumer.region:us-east-1}")
    private String region;

    @Value("${'${aws.sqs.consumer.access-key:}")
    private String accessKey;

    @Value("${'${aws.sqs.consumer.secret-key:}")
    private String secretKey;

    @Value("${'${aws.sqs.consumer.max-concurrent-messages:10}")
    private int maxConcurrentMessages;

    @Value("${'${aws.sqs.consumer.poll-timeout:10}")
    private int pollTimeoutSeconds;

    @Bean
    public SqsAsyncClient sqsAsyncClientConsumer() {
        var builder = SqsAsyncClient.builder()
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

    @Bean
    public SqsMessageListenerContainerFactory<Object> defaultSqsListenerContainerFactory(
            SqsAsyncClient sqsAsyncClientConsumer) {
        return SqsMessageListenerContainerFactory
                .builder()
                .sqsAsyncClient(sqsAsyncClientConsumer)
                .configure(options -> options
                        .maxConcurrentMessages(maxConcurrentMessages)
                        .pollTimeout(Duration.ofSeconds(pollTimeoutSeconds))
                )
                .build();
    }

    @Bean
    public SqsTemplate sqsTemplate(SqsAsyncClient sqsAsyncClientConsumer) {
        return SqsTemplate.newTemplate(sqsAsyncClientConsumer);
    }
}
