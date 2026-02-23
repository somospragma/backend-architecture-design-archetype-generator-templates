package ${basePackage}.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * Bean configuration for dependency injection.
 * Scans and registers all components from use cases and adapters.
 * This centralizes Spring framework concerns in the application layer,
 * keeping domain layers framework-agnostic.
 */
@Configuration
@ComponentScan(basePackages = {
    "${basePackage}.domain.usecase",
    "${basePackage}.infrastructure.adapter",
    "${basePackage}.infrastructure.entrypoint"
})
public class BeanConfiguration {
    // Spring will automatically register all beans from scanned packages
}
