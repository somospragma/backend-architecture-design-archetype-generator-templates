package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.Arrays;
import java.util.List;

/**
 * HTTP Client adapter for ${r"${adapterName}"}.
 * Implements HTTP operations using RestClient (Spring 6.1+).
 */
@Component
public class ${r"${adapterName}"}HttpClientAdapter implements I${r"${entityName}"}Gateway {

    private final RestClient restClient;
    private final ${r"${entityName}"}EntityMapper mapper;

    public ${r"${adapterName}"}HttpClientAdapter(RestClient.Builder restClientBuilder, ${r"${entityName}"}EntityMapper mapper) {
        this.restClient = restClientBuilder.build();
        this.mapper = mapper;
    }

    /**
     * Performs a GET request.
     */
    public <T> T get(String uri, Class<T> responseType) {
        return restClient.get()
                .uri(uri)
                .retrieve()
                .body(responseType);
    }

    /**
     * Performs a GET request returning ResponseEntity.
     */
    public <T> ResponseEntity<T> getEntity(String uri, Class<T> responseType) {
        return restClient.get()
                .uri(uri)
                .retrieve()
                .toEntity(responseType);
    }

    /**
     * Performs a GET request returning a list.
     */
    public <T> List<T> getList(String uri, Class<T[]> responseType) {
        T[] response = restClient.get()
                .uri(uri)
                .retrieve()
                .body(responseType);
        return response != null ? Arrays.asList(response) : List.of();
    }

    /**
     * Performs a POST request.
     */
    public <T, R> R post(String uri, T body, Class<R> responseType) {
        return restClient.post()
                .uri(uri)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .body(responseType);
    }

    /**
     * Performs a POST request returning ResponseEntity.
     */
    public <T, R> ResponseEntity<R> postEntity(String uri, T body, Class<R> responseType) {
        return restClient.post()
                .uri(uri)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .toEntity(responseType);
    }

    /**
     * Performs a PUT request.
     */
    public <T> void put(String uri, T body) {
        restClient.put()
                .uri(uri)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .toBodilessEntity();
    }

    /**
     * Performs a PATCH request.
     */
    public <T, R> R patch(String uri, T body, Class<R> responseType) {
        return restClient.patch()
                .uri(uri)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .body(responseType);
    }

    /**
     * Performs a DELETE request.
     */
    public void delete(String uri) {
        restClient.delete()
                .uri(uri)
                .retrieve()
                .toBodilessEntity();
    }
}
