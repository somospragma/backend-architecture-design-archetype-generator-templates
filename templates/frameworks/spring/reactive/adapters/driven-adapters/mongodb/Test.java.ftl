package ${packageName};

import ${modelPackage}.${entityName};
import ${packageName}.mapper.${entityName}EntityMapper;
import ${packageName}.entity.${entityName}Entity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

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
        when(repository.save(any())).thenReturn(Mono.just(entity));
        when(mapper.toDomain(any())).thenReturn(domain);

        // When & Then
        StepVerifier.create(adapter.save(domain))
            .expectNext(domain)
            .verifyComplete();
    }

    @Test
    void findById_shouldReturnEntityFromMongoDB() {
        // Given
        String id = "test-id";
        ${entityName}Entity entity = new ${entityName}Entity();
        ${entityName} domain = new ${entityName}();

        when(repository.findById(anyString())).thenReturn(Mono.just(entity));
        when(mapper.toDomain(any())).thenReturn(domain);

        // When & Then
        StepVerifier.create(adapter.findById(id))
            .expectNext(domain)
            .verifyComplete();
    }

    @Test
    void findAll_shouldReturnAllEntities() {
        // Given
        ${entityName}Entity entity = new ${entityName}Entity();
        ${entityName} domain = new ${entityName}();

        when(repository.findAll()).thenReturn(Flux.just(entity));
        when(mapper.toDomain(any())).thenReturn(domain);

        // When & Then
        StepVerifier.create(adapter.findAll())
            .expectNext(domain)
            .verifyComplete();
    }

    @Test
    void deleteById_shouldDeleteEntityFromMongoDB() {
        // Given
        String id = "test-id";
        when(repository.deleteById(anyString())).thenReturn(Mono.empty());

        // When & Then
        StepVerifier.create(adapter.deleteById(id))
            .verifyComplete();
    }

    @Test
    void existsById_shouldReturnTrue() {
        // Given
        String id = "test-id";
        when(repository.existsById(anyString())).thenReturn(Mono.just(true));

        // When & Then
        StepVerifier.create(adapter.existsById(id))
            .expectNext(true)
            .verifyComplete();
    }
}
