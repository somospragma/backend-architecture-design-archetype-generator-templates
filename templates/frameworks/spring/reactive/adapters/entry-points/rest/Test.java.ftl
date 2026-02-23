package ${packageName}.infrastructure.entry-points.rest;

import ${packageName}.domain.port.in.${useCasePort};
import ${packageName}.infrastructure.entry-points.rest.dto.${controllerName}Request;
import ${packageName}.infrastructure.entry-points.rest.dto.${controllerName}Response;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.reactive.server.WebTestClient;
import reactor.core.publisher.Mono;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

/**
 * Unit tests for ${controllerName}Controller.
 */
@WebFluxTest(${controllerName}Controller.class)
class ${controllerName}ControllerTest {

  @Autowired
  private WebTestClient webTestClient;

  @MockBean
  private ${useCasePort} ${useCasePort?uncap_first};

  @Test
  void create_shouldReturnCreatedResponse() {
    // Given
    ${controllerName}Request request = new ${controllerName}Request("1", "Test");
    ${controllerName}Response response = new ${controllerName}Response("1", "Test", null);
    
    when(${useCasePort?uncap_first}.execute(any())).thenReturn(Mono.just(response));

    // When & Then
    webTestClient.post()
        .uri("${basePath}")
        .contentType(MediaType.APPLICATION_JSON)
        .bodyValue(request)
        .exchange()
        .expectStatus().isCreated()
        .expectBody(${controllerName}Response.class)
        .isEqualTo(response);
  }

  @Test
  void getById_shouldReturnEntity() {
    // Given
    String id = "1";
    ${controllerName}Response response = new ${controllerName}Response(id, "Test", null);
    
    when(${useCasePort?uncap_first}.findById(id)).thenReturn(Mono.just(response));

    // When & Then
    webTestClient.get()
        .uri("${basePath}/{id}", id)
        .exchange()
        .expectStatus().isOk()
        .expectBody(${controllerName}Response.class)
        .isEqualTo(response);
  }

  @Test
  void getById_shouldReturnNotFoundWhenEntityDoesNotExist() {
    // Given
    String id = "999";
    when(${useCasePort?uncap_first}.findById(id)).thenReturn(Mono.empty());

    // When & Then
    webTestClient.get()
        .uri("${basePath}/{id}", id)
        .exchange()
        .expectStatus().isNotFound();
  }
}
