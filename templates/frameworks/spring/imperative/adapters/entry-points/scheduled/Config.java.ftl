package ${packageName}.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Configuration for scheduled tasks
 * Enables Spring's scheduled task execution capability
 */
@Configuration
@EnableScheduling
public class ${adapterName}SchedulingConfig {
    // Spring will automatically detect @Scheduled methods
    // and execute them according to their configuration
}
