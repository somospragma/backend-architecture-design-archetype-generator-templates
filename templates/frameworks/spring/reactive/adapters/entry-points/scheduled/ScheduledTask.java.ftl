package ${packageName};

<#if useCaseName?? && useCaseName?has_content>
import ${useCaseImport};
</#if>
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

/**
 * Scheduled task for ${adapterName}
 * Executes periodically based on configured schedule
 * Uses reactive programming with Project Reactor
 */
@Component
public class ${adapterName}ScheduledTask {

    private static final Logger logger = LoggerFactory.getLogger(${adapterName}ScheduledTask.class);

<#if useCaseName??>
    private final ${useCaseType} ${useCaseName?uncap_first}UseCase;

    public ${adapterName}ScheduledTask(${useCaseType} ${useCaseName?uncap_first}UseCase) {
        this.${useCaseName?uncap_first}UseCase = ${useCaseName?uncap_first}UseCase;
    }
</#if>

    /**
     * Scheduled task execution
     * Default: runs every 5 minutes
     * Customize the cron expression in application.yml: scheduled.${adapterName?lower_case}.cron
     */
    @Scheduled(cron = "${'$'}{scheduled.${adapterName?lower_case}.cron:0 */5 * * * *}")
    public void execute() {
        logger.info("Executing scheduled task: ${adapterName}");
        
        executeReactive()
            .doOnSuccess(result -> logger.info("Scheduled task ${adapterName} completed successfully"))
            .doOnError(error -> logger.error("Error executing scheduled task ${adapterName}", error))
            .subscribe();
    }

    /**
     * Reactive execution logic
     * Override this method to implement your scheduled task logic
     */
    private Mono<Void> executeReactive() {
<#if useCaseName?? && useCaseName?has_content>
        // TODO: call the use case, e.g. return ${useCaseName?uncap_first}UseCase.<method>(...).then();
        return Mono.empty();
<#else>
        return Mono.fromRunnable(() -> {
            // TODO: Implement scheduled task logic
            logger.info("Scheduled task ${adapterName} executed - implement your logic here");
        });
</#if>
    }

    /**
     * Alternative: Fixed delay execution
     * Uncomment and customize as needed
     */
    // @Scheduled(fixedDelayString = "${'$'}{scheduled.${adapterName?lower_case}.fixed-delay:300000}")
    // public void executeWithFixedDelay() {
    //     execute();
    // }

    /**
     * Alternative: Fixed rate execution
     * Uncomment and customize as needed
     */
    // @Scheduled(fixedRateString = "${'$'}{scheduled.${adapterName?lower_case}.fixed-rate:300000}")
    // public void executeWithFixedRate() {
    //     execute();
    // }
}
