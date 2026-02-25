package ${packageName};

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.*;

import java.util.List;
import java.util.Map;

/**
 * SQS Producer adapter for ${adapterName}.
 * Implements SQS message sending operations using SqsClient (synchronous).
 */
@Component
public class ${adapterName}SqsProducerAdapter {

    private final SqsClient sqsClient;
    private final String queueUrl;

    public ${adapterName}SqsProducerAdapter(
            SqsClient sqsClient,
            @Value("${'${aws.sqs.queue-url}") String queueUrl) {
        this.sqsClient = sqsClient;
        this.queueUrl = queueUrl;
    }

    /**
     * Sends a message to the SQS queue.
     */
    public void sendMessage(String messageBody) {
        SendMessageRequest request = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .build();

        sqsClient.sendMessage(request);
    }

    /**
     * Sends a message with attributes to the SQS queue.
     */
    public void sendMessage(String messageBody, Map<String, MessageAttributeValue> attributes) {
        SendMessageRequest request = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .messageAttributes(attributes)
                .build();

        sqsClient.sendMessage(request);
    }

    /**
     * Sends a message with delay to the SQS queue.
     */
    public void sendMessageWithDelay(String messageBody, int delaySeconds) {
        SendMessageRequest request = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .delaySeconds(delaySeconds)
                .build();

        sqsClient.sendMessage(request);
    }

    /**
     * Sends a batch of messages to the SQS queue.
     */
    public SendMessageBatchResponse sendMessageBatch(List<SendMessageBatchRequestEntry> entries) {
        SendMessageBatchRequest request = SendMessageBatchRequest.builder()
                .queueUrl(queueUrl)
                .entries(entries)
                .build();

        return sqsClient.sendMessageBatch(request);
    }

    /**
     * Gets the queue URL by queue name.
     */
    public String getQueueUrl(String queueName) {
        GetQueueUrlRequest request = GetQueueUrlRequest.builder()
                .queueName(queueName)
                .build();

        GetQueueUrlResponse response = sqsClient.getQueueUrl(request);
        return response.queueUrl();
    }
}
