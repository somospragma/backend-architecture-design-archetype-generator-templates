package ${packageName};

import ${modelPackage}.${entityName};
import ${packageName}.mapper.${entityName}EntityMapper;
import ${packageName}.entity.${entityName}Entity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * Unit tests for ${adapterName}Adapter.
 */
@ExtendWith(MockitoExtension.class)
class ${adapterName}AdapterTest {

    @Mock
    private ${adapterName}Repository repository;

    @Mock
    private ${entityName}EntityMapper mapper;

    private ${adapterName}Adapter adapter;

    @BeforeEach
    void setUp() {
        adapter = new ${adapterName}Adapter(repository, mapper);
    }

    @Test
    void save_shouldSaveEntityToMongoDB() {
        // Given
        ${entityName} domain = new ${entityName}();
        ${entityName}Entity entity = new ${entityName}Entity();

        when(mapper.toEntity(any())).thenReturn(entity);
        when(repository.save(any())).thenReturn(entity);
        when(mapper.toDomain(any())).thenReturn(domain);

        // When
        ${entityName} result = adapter.save(domain);

        // Then
        assertNotNull(result);
        verify(repository).save(entity);
    }

    @Test
    void findById_shouldReturnEntityFromMongoDB() {
        // Given
        String id = "test-id";
        ${entityName}Entity entity = new ${entityName}Entity();
        ${entityName} domain = new ${entityName}();

        when(repository.findById(anyString())).thenReturn(Optional.of(entity));
        when(mapper.toDomain(any())).thenReturn(domain);

        // When
        Optional<${entityName}> result = adapter.findById(id);

        // Then
        assertTrue(result.isPresent());
        assertEquals(domain, result.get());
    }

    @Test
    void findById_shouldReturnEmptyWhenNotFound() {
        // Given
        String id = "non-existent";
        when(repository.findById(anyString())).thenReturn(Optional.empty());

        // When
        Optional<${entityName}> result = adapter.findById(id);

        // Then
        assertTrue(result.isEmpty());
    }

    @Test
    void findAll_shouldReturnAllEntities() {
        // Given
        ${entityName}Entity entity = new ${entityName}Entity();
        ${entityName} domain = new ${entityName}();

        when(repository.findAll()).thenReturn(List.of(entity));
        when(mapper.toDomain(any())).thenReturn(domain);

        // When
        List<${entityName}> result = adapter.findAll();

        // Then
        assertEquals(1, result.size());
        assertEquals(domain, result.get(0));
    }

    @Test
    void deleteById_shouldDeleteEntityFromMongoDB() {
        // Given
        String id = "test-id";

        // When
        adapter.deleteById(id);

        // Then
        verify(repository).deleteById(id);
    }

    @Test
    void existsById_shouldReturnTrue() {
        // Given
        String id = "test-id";
        when(repository.existsById(anyString())).thenReturn(true);

        // When
        boolean result = adapter.existsById(id);

        // Then
        assertTrue(result);
    }
}
