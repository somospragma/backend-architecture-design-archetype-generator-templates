package ${packageName};

import okhttp3.mockwebserver.MockResponse;
import okhttp3.mockwebserver.MockWebServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.test.StepVerifier;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test for ${adapterName}HttpClientAdapter
 */
class ${adapterName}HttpClientAdapterTest {

    private MockWebServer mockWebServer;
    private ${adapterName}HttpClientAdapter adapter;

    @BeforeEach
    void setUp() throws IOException {
        mockWebServer = new MockWebServer();
        mockWebServer.start();

        WebClient webClient = WebClient.builder()
                .baseUrl(mockWebServer.url("/").toString())
                .build();

        adapter = new ${adapterName}HttpClientAdapter(webClient);
    }

    @AfterEach
    void tearDown() throws IOException {
        mockWebServer.shutdown();
    }

    @Test
    void testGet() {
        mockWebServer.enqueue(new MockResponse()
                .setBody("{\"id\":1,\"name\":\"Test\"}")
                .addHeader("Content-Type", "application/json"));

        StepVerifier.create(adapter.get("/test", String.class))
                .assertNext(response -> assertNotNull(response))
                .verifyComplete();
    }

    @Test
    void testPost() {
        mockWebServer.enqueue(new MockResponse()
                .setBody("{\"id\":1,\"name\":\"Created\"}")
                .addHeader("Content-Type", "application/json"));

        StepVerifier.create(adapter.post("/test", "{\"name\":\"Test\"}", String.class))
                .assertNext(response -> assertNotNull(response))
                .verifyComplete();
    }
}
