package ${packageName};

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Integration tests for ${controllerName}Controller.
 * Uses MockMvc to test HTTP endpoints without starting a full server.
 */
@WebMvcTest(${controllerName}Controller.class)
class ${controllerName}ControllerTest {

  private static final String BASE_PATH = "${basePath!'/api/' + controllerName?lower_case + 's'}";
  private static final String ID_PATH = BASE_PATH + "/{id}";
  private static final String TEST_ID = "test-id-123";

  @Autowired
  private MockMvc mockMvc;

  // TODO: Mock use case port
  // @MockBean
  // private ${controllerName}UseCase ${controllerName?uncap_first}UseCase;

  @Test
  void shouldCreateSuccessfully() throws Exception {
    // Given
    String requestBody = "{}"; // TODO: Replace with actual request DTO

    // When & Then
    mockMvc.perform(post(BASE_PATH)
            .contentType(MediaType.APPLICATION_JSON)
            .content(requestBody))
        .andExpect(status().isCreated());
  }

  @Test
  void shouldGetByIdSuccessfully() throws Exception {
    // When & Then
    mockMvc.perform(get(ID_PATH, TEST_ID)
            .contentType(MediaType.APPLICATION_JSON))
        .andExpect(status().isOk());
  }

  @Test
  void shouldGetAllSuccessfully() throws Exception {
    // When & Then
    mockMvc.perform(get(BASE_PATH)
            .contentType(MediaType.APPLICATION_JSON))
        .andExpect(status().isOk())
        .andExpect(content().contentType(MediaType.APPLICATION_JSON));
  }

  @Test
  void shouldUpdateSuccessfully() throws Exception {
    // Given
    String requestBody = "{}"; // TODO: Replace with actual request DTO

    // When & Then
    mockMvc.perform(put(ID_PATH, TEST_ID)
            .contentType(MediaType.APPLICATION_JSON)
            .content(requestBody))
        .andExpect(status().isOk());
  }

  @Test
  void shouldPatchSuccessfully() throws Exception {
    // Given
    String requestBody = "{}"; // TODO: Replace with actual request DTO

    // When & Then
    mockMvc.perform(patch(ID_PATH, TEST_ID)
            .contentType(MediaType.APPLICATION_JSON)
            .content(requestBody))
        .andExpect(status().isOk());
  }

  @Test
  void shouldDeleteSuccessfully() throws Exception {
    // When & Then
    mockMvc.perform(delete(ID_PATH, TEST_ID)
            .contentType(MediaType.APPLICATION_JSON))
        .andExpect(status().isNoContent());
  }
}
