package ${packageName}.domain.usecase;

import ${packageName}.domain.model.${entityName};
import ${packageName}.domain.port.out.${repositoryPort};
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

/**
 * Unit tests for ${useCaseName}UseCase.
 */
@ExtendWith(MockitoExtension.class)
class ${useCaseName}UseCaseTest {

  @Mock
  private ${repositoryPort} ${repositoryPort?uncap_first};

  private ${useCaseName}UseCase useCase;

  @BeforeEach
  void setUp() {
    useCase = new ${useCaseName}UseCase(${repositoryPort?uncap_first});
  }

  @Test
  void execute_shouldSaveEntity() {
    // Given
    ${entityName} entity = new ${entityName}();
    // TODO: Set entity properties
    
    when(${repositoryPort?uncap_first}.save(any())).thenReturn(Mono.just(entity));

    // When & Then
    StepVerifier.create(useCase.execute(entity))
        .expectNext(entity)
        .verifyComplete();
  }

  @Test
  void findById_shouldReturnEntity() {
    // Given
    String id = "test-id";
    ${entityName} entity = new ${entityName}();
    // TODO: Set entity properties
    
    when(${repositoryPort?uncap_first}.findById(anyString())).thenReturn(Mono.just(entity));

    // When & Then
    StepVerifier.create(useCase.findById(id))
        .expectNext(entity)
        .verifyComplete();
  }

  @Test
  void delete_shouldDeleteEntity() {
    // Given
    String id = "test-id";
    when(${repositoryPort?uncap_first}.deleteById(anyString())).thenReturn(Mono.just(true));

    // When & Then
    StepVerifier.create(useCase.delete(id))
        .verifyComplete();
  }
}
