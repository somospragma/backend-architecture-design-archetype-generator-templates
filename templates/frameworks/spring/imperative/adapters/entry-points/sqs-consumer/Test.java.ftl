package ${packageName};

import io.awspring.cloud.sqs.operations.SqsTemplate;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.messaging.Message;
import org.springframework.messaging.support.MessageBuilder;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.localstack.LocalStackContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;
import software.amazon.awssdk.services.sqs.SqsAsyncClient;
import software.amazon.awssdk.services.sqs.model.CreateQueueRequest;

import java.time.Duration;

import static org.awaitility.Awaitility.await;
import static org.testcontainers.containers.localstack.LocalStackContainer.Service.SQS;

/**
 * Test for ${adapterName}SqsConsumer using LocalStack
 */
@SpringBootTest
@Testcontainers
class ${adapterName}SqsConsumerTest {

    @Container
    static LocalStackContainer localstack = new LocalStackContainer(
            DockerImageName.parse("localstack/localstack:latest"))
            .withServices(SQS);

    @Autowired
    private SqsTemplate sqsTemplate;

    @Autowired
    private SqsAsyncClient sqsAsyncClientConsumer;

    private String queueName = "${adapterName?lower_case}-test-queue";
    private String queueUrl;

    @DynamicPropertySource
    static void properties(DynamicPropertyRegistry registry) {
        registry.add("aws.sqs.consumer.endpoint", () -> localstack.getEndpointOverride(SQS).toString());
        registry.add("aws.sqs.consumer.region", localstack::getRegion);
        registry.add("aws.sqs.consumer.access-key", localstack::getAccessKey);
        registry.add("aws.sqs.consumer.secret-key", localstack::getSecretKey);
        registry.add("aws.sqs.consumer.queue-name", () -> "${adapterName?lower_case}-test-queue");
    }

    @BeforeEach
    void setUp() {
        // Create queue
        CreateQueueRequest createQueueRequest = CreateQueueRequest.builder()
                .queueName(queueName)
                .build();

        queueUrl = sqsAsyncClientConsumer.createQueue(createQueueRequest).join().queueUrl();
    }

    @Test
    void testReceiveMessage() {
        // Send a test message
        String testMessage = "Test message content";
        Message<String> message = MessageBuilder.withPayload(testMessage).build();
        
        sqsTemplate.send(queueName, message);

        // Wait for message to be processed
        await()
                .atMost(Duration.ofSeconds(10))
                .pollInterval(Duration.ofMillis(500))
                .untilAsserted(() -> {
                    // Add assertions here to verify message was processed
                    // For example, check database, mock service calls, etc.
                });
    }

    @Test
    void testReceiveMultipleMessages() {
        // Send multiple test messages
        for (int i = 0; i < 5; i++) {
            String testMessage = "Test message " + i;
            Message<String> message = MessageBuilder.withPayload(testMessage).build();
            sqsTemplate.send(queueName, message);
        }

        // Wait for messages to be processed
        await()
                .atMost(Duration.ofSeconds(15))
                .pollInterval(Duration.ofMillis(500))
                .untilAsserted(() -> {
                    // Add assertions here to verify all messages were processed
                });
    }
}
