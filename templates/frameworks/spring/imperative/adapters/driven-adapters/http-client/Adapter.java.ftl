package ${packageName};

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.List;

/**
 * HTTP Client adapter for ${adapterName}.
 * Implements HTTP operations using RestTemplate.
 */
@Component
public class ${adapterName}HttpClientAdapter {

    private final RestTemplate restTemplate;

    public ${adapterName}HttpClientAdapter(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * Performs a GET request.
     */
    public <T> T get(String uri, Class<T> responseType) {
        return restTemplate.getForObject(uri, responseType);
    }

    /**
     * Performs a GET request returning ResponseEntity.
     */
    public <T> ResponseEntity<T> getEntity(String uri, Class<T> responseType) {
        return restTemplate.getForEntity(uri, responseType);
    }

    /**
     * Performs a GET request returning a list.
     */
    public <T> List<T> getList(String uri, Class<T[]> responseType) {
        T[] response = restTemplate.getForObject(uri, responseType);
        return response != null ? Arrays.asList(response) : List.of();
    }

    /**
     * Performs a POST request.
     */
    public <T, R> R post(String uri, T body, Class<R> responseType) {
        return restTemplate.postForObject(uri, body, responseType);
    }

    /**
     * Performs a POST request returning ResponseEntity.
     */
    public <T, R> ResponseEntity<R> postEntity(String uri, T body, Class<R> responseType) {
        return restTemplate.postForEntity(uri, body, responseType);
    }

    /**
     * Performs a PUT request.
     */
    public <T> void put(String uri, T body) {
        restTemplate.put(uri, body);
    }

    /**
     * Performs a PATCH request.
     */
    public <T, R> R patch(String uri, T body, Class<R> responseType) {
        return restTemplate.patchForObject(uri, body, responseType);
    }

    /**
     * Performs a DELETE request.
     */
    public void delete(String uri) {
        restTemplate.delete(uri);
    }
}
