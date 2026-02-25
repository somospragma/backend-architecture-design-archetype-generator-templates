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
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.*;

import java.util.Arrays;

import static org.assertj.core.api.Assertions.assertThat;
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
    private SqsClient sqsClient;
    private String queueUrl;

    @BeforeEach
    void setUp() {
        sqsClient = SqsClient.builder()
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

        queueUrl = sqsClient.createQueue(createQueueRequest).queueUrl();

        adapter = new ${adapterName}SqsProducerAdapter(sqsClient, queueUrl);
    }

    @Test
    void testSendMessage() {
        // Given
        String messageBody = "Test message";

        // When
        adapter.sendMessage(messageBody);

        // Then - verify message was sent by receiving it
        ReceiveMessageRequest receiveRequest = ReceiveMessageRequest.builder()
                .queueUrl(queueUrl)
                .maxNumberOfMessages(1)
                .build();

        ReceiveMessageResponse response = sqsClient.receiveMessage(receiveRequest);
        
        assertThat(response.messages()).hasSize(1);
        assertThat(response.messages().get(0).body()).isEqualTo(messageBody);
    }

    @Test
    void testSendMessageWithAttributes() {
        // Given
        String messageBody = "Test message with attributes";
        var attributes = java.util.Map.of(
                "attribute1", MessageAttributeValue.builder()
                        .dataType("String")
                        .stringValue("value1")
                        .build()
        );

        // When
        adapter.sendMessage(messageBody, attributes);

        // Then
        ReceiveMessageRequest receiveRequest = ReceiveMessageRequest.builder()
                .queueUrl(queueUrl)
                .maxNumberOfMessages(1)
                .messageAttributeNames("All")
                .build();

        ReceiveMessageResponse response = sqsClient.receiveMessage(receiveRequest);
        
        assertThat(response.messages()).hasSize(1);
        assertThat(response.messages().get(0).body()).isEqualTo(messageBody);
        assertThat(response.messages().get(0).messageAttributes()).containsKey("attribute1");
    }

    @Test
    void testSendMessageBatch() {
        // Given
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

        // When
        SendMessageBatchResponse response = adapter.sendMessageBatch(entries);

        // Then
        assertThat(response.successful()).hasSize(2);
        assertThat(response.failed()).isEmpty();
    }

    @Test
    void testGetQueueUrl() {
        // When
        String retrievedUrl = adapter.getQueueUrl("${adapterName?lower_case}-test-queue");

        // Then
        assertThat(retrievedUrl).isNotNull();
        assertThat(retrievedUrl).contains("${adapterName?lower_case}-test-queue");
    }
}
