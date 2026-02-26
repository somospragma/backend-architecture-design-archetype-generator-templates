package ${packageName};

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Scheduled task for ${adapterName}
 * Executes periodically based on configured schedule
 */
@Component
public class ${adapterName}ScheduledTask {

    private static final Logger logger = LoggerFactory.getLogger(${adapterName}ScheduledTask.class);

<#if useCaseName??>
    private final ${useCaseName}UseCase ${useCaseName?uncap_first}UseCase;

    public ${adapterName}ScheduledTask(${useCaseName}UseCase ${useCaseName?uncap_first}UseCase) {
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
        
        try {
<#if useCaseName??>
            // Execute use case
            ${useCaseName?uncap_first}UseCase.execute();
            logger.info("Scheduled task ${adapterName} completed successfully");
<#else>
            // TODO: Implement scheduled task logic
            logger.info("Scheduled task ${adapterName} executed - implement your logic here");
</#if>
        } catch (Exception e) {
            logger.error("Error executing scheduled task ${adapterName}", e);
        }
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
