package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;
import software.amazon.awssdk.services.sqs.SqsAsyncClient;
import software.amazon.awssdk.services.sqs.model.*;

import java.util.Map;

/**
 * SQS Producer adapter for ${r"${adapterName}"}.
 * Implements SQS message sending operations using SqsAsyncClient.
 */
@Component
@RequiredArgsConstructor
public class ${r"${adapterName}"}SqsProducerAdapter implements I${r"${entityName}"}Gateway {

    private final SqsAsyncClient sqsAsyncClient;
    private final ${r"${entityName}"}EntityMapper mapper;

    @Value("${r"${"}aws.sqs.queue-url}")
    private String queueUrl;

    /**
     * Sends a message to the SQS queue.
     */
    public Mono<SendMessageResponse> sendMessage(String messageBody) {
        SendMessageRequest request = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .build();

        return Mono.fromCompletionStage(sqsAsyncClient.sendMessage(request));
    }

    /**
     * Sends a message with attributes to the SQS queue.
     */
    public Mono<SendMessageResponse> sendMessage(String messageBody, Map<String, MessageAttributeValue> attributes) {
        SendMessageRequest request = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .messageAttributes(attributes)
                .build();

        return Mono.fromCompletionStage(sqsAsyncClient.sendMessage(request));
    }

    /**
     * Sends a message with delay to the SQS queue.
     */
    public Mono<SendMessageResponse> sendMessageWithDelay(String messageBody, int delaySeconds) {
        SendMessageRequest request = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .delaySeconds(delaySeconds)
                .build();

        return Mono.fromCompletionStage(sqsAsyncClient.sendMessage(request));
    }

    /**
     * Sends a batch of messages to the SQS queue.
     */
    public Mono<SendMessageBatchResponse> sendMessageBatch(java.util.List<SendMessageBatchRequestEntry> entries) {
        SendMessageBatchRequest request = SendMessageBatchRequest.builder()
                .queueUrl(queueUrl)
                .entries(entries)
                .build();

        return Mono.fromCompletionStage(sqsAsyncClient.sendMessageBatch(request));
    }

    /**
     * Gets the queue URL by queue name.
     */
    public Mono<String> getQueueUrl(String queueName) {
        GetQueueUrlRequest request = GetQueueUrlRequest.builder()
                .queueName(queueName)
                .build();

        return Mono.fromCompletionStage(sqsAsyncClient.getQueueUrl(request))
                .map(GetQueueUrlResponse::queueUrl);
    }
}
