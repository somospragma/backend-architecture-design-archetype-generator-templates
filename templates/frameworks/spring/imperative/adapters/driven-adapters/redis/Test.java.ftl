package ${packageName}.infrastructure.driven-adapters.redis;

import ${packageName}.domain.model.${entityName};
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.util.Optional;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Unit tests for ${adapterName}RedisAdapter.
 */
@ExtendWith(MockitoExtension.class)
class ${adapterName}RedisAdapterTest {

  @Mock
  private RedisTemplate<String, ${entityName}> redisTemplate;

  @Mock
  private ValueOperations<String, ${entityName}> valueOperations;

  private ${adapterName}RedisAdapter adapter;

  @BeforeEach
  void setUp() {
    when(redisTemplate.opsForValue()).thenReturn(valueOperations);
    adapter = new ${adapterName}RedisAdapter(redisTemplate);
  }

  @Test
  void save_shouldSaveEntityToRedis() {
    // Given
    String id = "test-id";
    ${entityName} entity = new ${entityName}();
    // TODO: Set entity properties

    // When
    ${entityName} result = adapter.save(id, entity);

    // Then
    assertThat(result).isEqualTo(entity);
    verify(valueOperations).set(
        eq("${entityName?lower_case}:" + id), 
        eq(entity), 
        eq(3600L), 
        eq(TimeUnit.SECONDS)
    );
  }

  @Test
  void findById_shouldReturnEntityFromRedis() {
    // Given
    String id = "test-id";
    ${entityName} entity = new ${entityName}();
    // TODO: Set entity properties
    
    when(valueOperations.get(anyString())).thenReturn(entity);

    // When
    Optional<${entityName}> result = adapter.findById(id);

    // Then
    assertThat(result).isPresent();
    assertThat(result.get()).isEqualTo(entity);
    verify(valueOperations).get("${entityName?lower_case}:" + id);
  }

  @Test
  void findById_shouldReturnEmptyWhenNotFound() {
    // Given
    String id = "test-id";
    when(valueOperations.get(anyString())).thenReturn(null);

    // When
    Optional<${entityName}> result = adapter.findById(id);

    // Then
    assertThat(result).isEmpty();
  }

  @Test
  void deleteById_shouldDeleteEntityFromRedis() {
    // Given
    String id = "test-id";
    when(redisTemplate.delete(anyString())).thenReturn(true);

    // When
    boolean result = adapter.deleteById(id);

    // Then
    assertThat(result).isTrue();
    verify(redisTemplate).delete("${entityName?lower_case}:" + id);
  }

  @Test
  void existsById_shouldReturnTrueWhenExists() {
    // Given
    String id = "test-id";
    when(redisTemplate.hasKey(anyString())).thenReturn(true);

    // When
    boolean result = adapter.existsById(id);

    // Then
    assertThat(result).isTrue();
    verify(redisTemplate).hasKey("${entityName?lower_case}:" + id);
  }

  @Test
  void deleteAll_shouldDeleteAllEntities() {
    // Given
    Set<String> keys = Set.of(
        "${entityName?lower_case}:1", 
        "${entityName?lower_case}:2"
    );
    when(redisTemplate.keys(anyString())).thenReturn(keys);

    // When
    adapter.deleteAll();

    // Then
    verify(redisTemplate).keys("${entityName?lower_case}:*");
    verify(redisTemplate).delete(keys);
  }
}
