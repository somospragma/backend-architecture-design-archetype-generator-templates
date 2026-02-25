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
import software.amazon.awssdk.services.sqs.SqsAsyncClient;
import software.amazon.awssdk.services.sqs.model.*;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;
import static org.testcontainers.containers.localstack.LocalStackContainer.Service.SQS;

/**
 * Test for ${adapterName}SqsProducerAdapter using LocalStack
 */
@Testcontainers
class ${adapterName}SqsProducerAdapterTest {

    @Container
    static LocalStackContainer localstack = new LocalStackContainer(
            DockerImageName.parse("localstack/localstack:latest"))
            .withServices(SQS);

    private ${adapterName}SqsProducerAdapter adapter;
    private SqsAsyncClient sqsAsyncClient;
    private String queueUrl;

    @BeforeEach
    void setUp() {
        sqsAsyncClient = SqsAsyncClient.builder()
                .endpointOverride(localstack.getEndpointOverride(SQS))
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

        // Create queue
        CreateQueueRequest createQueueRequest = CreateQueueRequest.builder()
                .queueName("${adapterName?lower_case}-test-queue")
                .build();

        queueUrl = sqsAsyncClient.createQueue(createQueueRequest).join().queueUrl();

        adapter = new ${adapterName}SqsProducerAdapter(sqsAsyncClient, queueUrl);
    }

    @Test
    void testSendMessage() {
        String messageBody = "Test message";

        StepVerifier.create(adapter.sendMessage(messageBody))
                .assertNext(response -> {
                    assertNotNull(response.messageId());
                    assertFalse(response.messageId().isEmpty());
                })
                .verifyComplete();
    }

    @Test
    void testSendMessageWithAttributes() {
        String messageBody = "Test message with attributes";
        var attributes = java.util.Map.of(
                "attribute1", MessageAttributeValue.builder()
                        .dataType("String")
                        .stringValue("value1")
                        .build()
        );

        StepVerifier.create(adapter.sendMessage(messageBody, attributes))
                .assertNext(response -> {
                    assertNotNull(response.messageId());
                    assertFalse(response.messageId().isEmpty());
                })
                .verifyComplete();
    }

    @Test
    void testSendMessageWithDelay() {
        String messageBody = "Delayed message";
        int delaySeconds = 5;

        StepVerifier.create(adapter.sendMessageWithDelay(messageBody, delaySeconds))
                .assertNext(response -> {
                    assertNotNull(response.messageId());
                    assertFalse(response.messageId().isEmpty());
                })
                .verifyComplete();
    }

    @Test
    void testSendMessageBatch() {
        var entries = Arrays.asList(
                SendMessageBatchRequestEntry.builder()
                        .id("msg1")
                        .messageBody("Message 1")
                        .build(),
                SendMessageBatchRequestEntry.builder()
                        .id("msg2")
                        .messageBody("Message 2")
                        .build()
        );

        StepVerifier.create(adapter.sendMessageBatch(entries))
                .assertNext(response -> {
                    assertEquals(2, response.successful().size());
                    assertTrue(response.failed().isEmpty());
                })
                .verifyComplete();
    }

    @Test
    void testGetQueueUrl() {
        StepVerifier.create(adapter.getQueueUrl("${adapterName?lower_case}-test-queue"))
                .assertNext(url -> {
                    assertNotNull(url);
                    assertTrue(url.contains("${adapterName?lower_case}-test-queue"));
                })
                .verifyComplete();
    }
}
