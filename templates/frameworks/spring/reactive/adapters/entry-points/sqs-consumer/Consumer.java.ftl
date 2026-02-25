package ${packageName};

import io.awspring.cloud.sqs.annotation.SqsListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.Message;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

/**
 * SQS Consumer for ${adapterName}.
 * Listens to SQS messages and processes them reactively.
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
        processMessage(message)
                .subscribeOn(Schedulers.boundedElastic())
                .doOnSuccess(result -> logger.info("Successfully processed message: {}", message.getPayload()))
                .doOnError(error -> logger.error("Error processing message: {}", message.getPayload(), error))
                .subscribe();
    }

    /**
     * Processes the message reactively.
     * Override this method to implement custom message processing logic.
     */
    protected Mono<Void> processMessage(Message<String> message) {
        return Mono.fromRunnable(() -> {
            String payload = message.getPayload();
            logger.info("Processing message: {}", payload);
            
            // Add your business logic here
            // Example: parse JSON, validate, call use case, etc.
            
        }).then();
    }

    /**
     * Processes messages with custom acknowledgment.
     * Use this when you need manual control over message acknowledgment.
     */
    @SqsListener(value = "${'${aws.sqs.consumer.queue-name}", acknowledgementMode = "MANUAL")
    public void receiveMessageWithManualAck(Message<String> message, 
                                            io.awspring.cloud.sqs.listener.acknowledgement.Acknowledgement acknowledgement) {
        processMessage(message)
                .subscribeOn(Schedulers.boundedElastic())
                .doOnSuccess(result -> {
                    acknowledgement.acknowledge();
                    logger.info("Message acknowledged: {}", message.getPayload());
                })
                .doOnError(error -> {
                    logger.error("Error processing message, will retry: {}", message.getPayload(), error);
                    // Message will be retried automatically if not acknowledged
                })
                .subscribe();
    }
}
