package ${packageName}.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;

/**
 * RestTemplate configuration for ${adapterName}.
 * Configures timeouts and interceptors.
 */
@Configuration
public class ${adapterName}RestTemplateConfig {

    @Value("${'${${adapterName?lower_case}.http.base-url}")
    private String baseUrl;

    @Value("${'${${adapterName?lower_case}.http.timeout:5000}")
    private int timeout;

    @Bean
    public RestTemplate ${adapterName?uncap_first}RestTemplate(RestTemplateBuilder builder) {
        return builder
                .rootUri(baseUrl)
                .setConnectTimeout(Duration.ofMillis(timeout))
                .setReadTimeout(Duration.ofMillis(timeout))
                .interceptors(loggingInterceptor())
                .build();
    }

    /**
     * Logging interceptor for debugging HTTP requests/responses.
     */
    private ClientHttpRequestInterceptor loggingInterceptor() {
        return (request, body, execution) -> {
            // Log request details if needed
            return execution.execute(request, body);
        };
    }
}
