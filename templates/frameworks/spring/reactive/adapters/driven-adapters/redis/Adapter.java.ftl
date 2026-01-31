package ${packageName}.infrastructure.driven-adapters.redis;

import ${packageName}.domain.model.${entityName};
import ${packageName}.domain.port.out.${portName};
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.time.Duration;

/**
 * Redis adapter for ${entityName}.
 * Implements caching using Redis with ${cacheStrategy} strategy.
 */
@Component
public class ${adapterName}RedisAdapter implements ${portName} {

  private final ReactiveRedisTemplate<String, ${entityName}> redisTemplate;
  private static final String KEY_PREFIX = "${keyPrefix}";
  private static final long TTL_SECONDS = ${ttl};

  public ${adapterName}RedisAdapter(
      ReactiveRedisTemplate<String, ${entityName}> redisTemplate) {
    this.redisTemplate = redisTemplate;
  }

  @Override
  public Mono<${entityName}> save(${entityName} entity) {
    String key = KEY_PREFIX + entity.getId();
    
    return redisTemplate.opsForValue()
        .set(key, entity, Duration.ofSeconds(TTL_SECONDS))
        .thenReturn(entity);
  }

  @Override
  public Mono<${entityName}> findById(String id) {
    String key = KEY_PREFIX + id;
    
    return redisTemplate.opsForValue()
        .get(key);
  }

  @Override
  public Flux<${entityName}> findAll() {
    String pattern = KEY_PREFIX + "*";
    
    return redisTemplate.keys(pattern)
        .flatMap(key -> redisTemplate.opsForValue().get(key));
  }

  @Override
  public Mono<Boolean> deleteById(String id) {
    String key = KEY_PREFIX + id;
    
    return redisTemplate.delete(key)
        .map(count -> count > 0);
  }

  @Override
  public Mono<Boolean> existsById(String id) {
    String key = KEY_PREFIX + id;
    
    return redisTemplate.hasKey(key);
  }
}
