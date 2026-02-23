package ${basePackage}.infrastructure.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * Bean configuration for dependency injection.
 * Scans and registers all components from application and infrastructure layers.
 * This centralizes Spring framework concerns in the infrastructure layer,
 * keeping domain and application layers framework-agnostic.
 */
@Configuration
@ComponentScan(basePackages = {
    "${basePackage}.application.usecase",
    "${basePackage}.infrastructure.drivenadapters",
    "${basePackage}.infrastructure.entrypoints"
})
public class BeanConfiguration {
    // Spring will automatically register all beans from scanned packages
}
