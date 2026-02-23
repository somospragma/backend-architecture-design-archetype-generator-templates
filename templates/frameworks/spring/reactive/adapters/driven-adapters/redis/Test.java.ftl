package ${packageName}.infrastructure.driven-adapters.redis;

import ${packageName}.domain.model.${entityName};
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.data.redis.core.ReactiveValueOperations;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

/**
 * Unit tests for ${adapterName}RedisAdapter.
 */
@ExtendWith(MockitoExtension.class)
class ${adapterName}RedisAdapterTest {

  @Mock
  private ReactiveRedisTemplate<String, ${entityName}> redisTemplate;

  @Mock
  private ReactiveValueOperations<String, ${entityName}> valueOperations;

  private ${adapterName}RedisAdapter adapter;

  @BeforeEach
  void setUp() {
    when(redisTemplate.opsForValue()).thenReturn(valueOperations);
    adapter = new ${adapterName}RedisAdapter(redisTemplate);
  }

  @Test
  void save_shouldSaveEntityToRedis() {
    // Given
    ${entityName} entity = new ${entityName}();
    // TODO: Set entity properties
    
    when(valueOperations.set(anyString(), any(), any())).thenReturn(Mono.just(true));

    // When & Then
    StepVerifier.create(adapter.save(entity))
        .expectNext(entity)
        .verifyComplete();
  }

  @Test
  void findById_shouldReturnEntityFromRedis() {
    // Given
    String id = "test-id";
    ${entityName} entity = new ${entityName}();
    // TODO: Set entity properties
    
    when(valueOperations.get(anyString())).thenReturn(Mono.just(entity));

    // When & Then
    StepVerifier.create(adapter.findById(id))
        .expectNext(entity)
        .verifyComplete();
  }

  @Test
  void deleteById_shouldDeleteEntityFromRedis() {
    // Given
    String id = "test-id";
    when(redisTemplate.delete(anyString())).thenReturn(Mono.just(1L));

    // When & Then
    StepVerifier.create(adapter.deleteById(id))
        .expectNext(true)
        .verifyComplete();
  }
}
