package ${packageName};

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
<#if useCaseName??>
import org.mockito.Mock;
</#if>
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.boot.test.context.SpringBootTest;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import java.util.concurrent.TimeUnit;

import static org.awaitility.Awaitility.await;
<#if useCaseName??>
import static org.mockito.Mockito.*;
</#if>

/**
 * Unit tests for ${adapterName}ScheduledTask
 */
@ExtendWith(MockitoExtension.class)
class ${adapterName}ScheduledTaskTest {

<#if useCaseName??>
    @Mock
    private ${useCaseName}UseCase ${useCaseName?uncap_first}UseCase;

</#if>
    @InjectMocks
    private ${adapterName}ScheduledTask scheduledTask;

    @Test
    void testExecute_Success() {
<#if useCaseName??>
        // Given
        when(${useCaseName?uncap_first}UseCase.execute()).thenReturn(Mono.empty());

</#if>
        // When
        scheduledTask.execute();

        // Wait for async execution
        await().atMost(5, TimeUnit.SECONDS).untilAsserted(() -> {
<#if useCaseName??>
            // Then
            verify(${useCaseName?uncap_first}UseCase, times(1)).execute();
</#if>
        });
    }

<#if useCaseName??>
    @Test
    void testExecute_HandlesException() {
        // Given
        when(${useCaseName?uncap_first}UseCase.execute())
            .thenReturn(Mono.error(new RuntimeException("Test exception")));

        // When
        scheduledTask.execute();

        // Wait for async execution
        await().atMost(5, TimeUnit.SECONDS).untilAsserted(() -> {
            // Then - should not throw exception, just log it
            verify(${useCaseName?uncap_first}UseCase, times(1)).execute();
        });
    }
</#if>
}

/**
 * Integration tests for scheduled task execution
 * Requires @EnableScheduling in test configuration
 */
@SpringBootTest
class ${adapterName}ScheduledTaskIntegrationTest {

    // Note: For integration testing of scheduled tasks, you may want to:
    // 1. Use a test-specific cron expression (e.g., every second)
    // 2. Use Awaitility to wait for task execution
    // 3. Verify side effects or use a test double to capture executions
    
    @Test
    void testScheduledExecution() {
        // Example using Awaitility to wait for scheduled execution
        await()
            .atMost(10, TimeUnit.SECONDS)
            .pollInterval(1, TimeUnit.SECONDS)
            .untilAsserted(() -> {
                // Add assertions here to verify scheduled task executed
                // For example, check database state, verify mock calls, etc.
            });
    }
}
