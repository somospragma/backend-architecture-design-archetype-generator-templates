package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * HTTP Client adapter for ${r"${adapterName}"}.
 * Implements HTTP operations using WebClient.
 */
@Component
@RequiredArgsConstructor
public class ${r"${adapterName}"}HttpClientAdapter implements I${r"${entityName}"}Gateway {

    private final WebClient webClient;
    private final ${r"${entityName}"}EntityMapper mapper;

    /**
     * Performs a GET request.
     */
    public <T> Mono<T> get(String uri, Class<T> responseType) {
        return webClient.get()
                .uri(uri)
                .retrieve()
                .bodyToMono(responseType);
    }

    /**
     * Performs a GET request returning a list.
     */
    public <T> Flux<T> getList(String uri, Class<T> responseType) {
        return webClient.get()
                .uri(uri)
                .retrieve()
                .bodyToFlux(responseType);
    }

    /**
     * Performs a POST request.
     */
    public <T, R> Mono<R> post(String uri, T body, Class<R> responseType) {
        return webClient.post()
                .uri(uri)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(responseType);
    }

    /**
     * Performs a PUT request.
     */
    public <T, R> Mono<R> put(String uri, T body, Class<R> responseType) {
        return webClient.put()
                .uri(uri)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(responseType);
    }

    /**
     * Performs a PATCH request.
     */
    public <T, R> Mono<R> patch(String uri, T body, Class<R> responseType) {
        return webClient.patch()
                .uri(uri)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(responseType);
    }

    /**
     * Performs a DELETE request.
     */
    public Mono<Void> delete(String uri) {
        return webClient.delete()
                .uri(uri)
                .retrieve()
                .bodyToMono(Void.class);
    }
}
