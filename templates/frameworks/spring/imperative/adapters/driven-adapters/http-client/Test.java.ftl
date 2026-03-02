package ${packageName};

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestTemplate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.*;
import static org.springframework.test.web.client.response.MockRestResponseCreators.*;

/**
 * Test for ${adapterName}HttpClientAdapter using MockRestServiceServer
 */
class ${adapterName}HttpClientAdapterTest {

    private MockRestServiceServer mockServer;
    private ${adapterName}HttpClientAdapter adapter;
    private RestTemplate restTemplate;

    @BeforeEach
    void setUp() {
        restTemplate = new RestTemplate();
        mockServer = MockRestServiceServer.createServer(restTemplate);
        adapter = new ${adapterName}HttpClientAdapter(restTemplate);
    }

    @Test
    void testGet() {
        // Given
        String expectedResponse = "{\"id\":1,\"name\":\"Test\"}";
        mockServer.expect(requestTo("/test"))
                .andExpect(method(HttpMethod.GET))
                .andRespond(withSuccess(expectedResponse, MediaType.APPLICATION_JSON));

        // When
        String response = adapter.get("/test", String.class);

        // Then
        assertThat(response).isEqualTo(expectedResponse);
        mockServer.verify();
    }

    @Test
    void testGetEntity() {
        // Given
        String expectedResponse = "{\"id\":1,\"name\":\"Test\"}";
        mockServer.expect(requestTo("/test"))
                .andExpect(method(HttpMethod.GET))
                .andRespond(withSuccess(expectedResponse, MediaType.APPLICATION_JSON));

        // When
        ResponseEntity<String> response = adapter.getEntity("/test", String.class);

        // Then
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isEqualTo(expectedResponse);
        mockServer.verify();
    }

    @Test
    void testPost() {
        // Given
        String requestBody = "{\"name\":\"Test\"}";
        String expectedResponse = "{\"id\":1,\"name\":\"Created\"}";
        
        mockServer.expect(requestTo("/test"))
                .andExpect(method(HttpMethod.POST))
                .andExpect(content().string(requestBody))
                .andRespond(withSuccess(expectedResponse, MediaType.APPLICATION_JSON));

        // When
        String response = adapter.post("/test", requestBody, String.class);

        // Then
        assertThat(response).isEqualTo(expectedResponse);
        mockServer.verify();
    }

    @Test
    void testPut() {
        // Given
        String requestBody = "{\"name\":\"Updated\"}";
        
        mockServer.expect(requestTo("/test/1"))
                .andExpect(method(HttpMethod.PUT))
                .andExpect(content().string(requestBody))
                .andRespond(withSuccess());

        // When
        adapter.put("/test/1", requestBody);

        // Then
        mockServer.verify();
    }

    @Test
    void testDelete() {
        // Given
        mockServer.expect(requestTo("/test/1"))
                .andExpect(method(HttpMethod.DELETE))
                .andRespond(withSuccess());

        // When
        adapter.delete("/test/1");

        // Then
        mockServer.verify();
    }
}
