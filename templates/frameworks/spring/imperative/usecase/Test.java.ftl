package ${packageName}.domain.usecase;

import ${packageName}.domain.model.${entityName};
import ${packageName}.domain.port.out.${repositoryPort};
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
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
    
    when(${repositoryPort?uncap_first}.save(any())).thenReturn(entity);

    // When
    ${entityName} result = useCase.execute(entity);

    // Then
    assertThat(result).isEqualTo(entity);
    verify(${repositoryPort?uncap_first}).save(any());
  }

  @Test
  void findById_shouldReturnEntity() {
    // Given
    String id = "test-id";
    ${entityName} entity = new ${entityName}();
    // TODO: Set entity properties
    
    when(${repositoryPort?uncap_first}.findById(anyString())).thenReturn(Optional.of(entity));

    // When
    Optional<${entityName}> result = useCase.findById(id);

    // Then
    assertThat(result).isPresent();
    assertThat(result.get()).isEqualTo(entity);
    verify(${repositoryPort?uncap_first}).findById(anyString());
  }

  @Test
  void delete_shouldDeleteEntity() {
    // Given
    String id = "test-id";

    // When
    useCase.delete(id);

    // Then
    verify(${repositoryPort?uncap_first}).deleteById(anyString());
  }
}
