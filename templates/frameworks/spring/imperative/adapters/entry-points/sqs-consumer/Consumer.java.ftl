package ${packageName};

import io.awspring.cloud.sqs.annotation.SqsListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.Message;
import org.springframework.stereotype.Component;

/**
 * SQS Consumer for ${adapterName}.
 * Listens to SQS messages and processes them synchronously.
 */
@Component
public class ${adapterName}SqsConsumer {

    private static final Logger logger = LoggerFactory.getLogger(${adapterName}SqsConsumer.class);

    /**
     * Processes messages from the SQS queue.
     * The @SqsListener annotation handles message polling and acknowledgment.
     */
    @SqsListener("${'${aws.sqs.consumer.queue-name}")
    public void receiveMessage(Message<String> message) {
        try {
            processMessage(message);
            logger.info("Successfully processed message: {}", message.getPayload());
        } catch (Exception e) {
            logger.error("Error processing message: {}", message.getPayload(), e);
            throw e; // Re-throw to trigger retry mechanism
        }
    }

    /**
     * Processes the message synchronously.
     * Override this method to implement custom message processing logic.
     */
    protected void processMessage(Message<String> message) {
        String payload = message.getPayload();
        logger.info("Processing message: {}", payload);
        
        // Add your business logic here
        // Example: parse JSON, validate, call use case, etc.
    }

    /**
     * Processes messages with custom acknowledgment.
     * Use this when you need manual control over message acknowledgment.
     */
    @SqsListener(value = "${'${aws.sqs.consumer.queue-name}", acknowledgementMode = "MANUAL")
    public void receiveMessageWithManualAck(Message<String> message, 
                                            io.awspring.cloud.sqs.listener.acknowledgement.Acknowledgement acknowledgement) {
        try {
            processMessage(message);
            acknowledgement.acknowledge();
            logger.info("Message acknowledged: {}", message.getPayload());
        } catch (Exception e) {
            logger.error("Error processing message, will retry: {}", message.getPayload(), e);
            // Message will be retried automatically if not acknowledged
        }
    }
}
