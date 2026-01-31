package ${packageName};

import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import ${packageName}.entity.${entityName}Data;
import ${packageName}.mapper.${entityName}Mapper;

/**
 * Redis adapter for ${entityName}.
 * Implements the output port for ${entityName} persistence using Redis.
 */
@Component
public class ${adapterName}Adapter {

  private final ReactiveRedisTemplate<String, ${entityName}Data> redisTemplate;
  private final ${entityName}Mapper mapper;
  private static final String KEY_PREFIX = "${entityName?lower_case}:";

  public ${adapterName}Adapter(
      ReactiveRedisTemplate<String, ${entityName}Data> redisTemplate,
      ${entityName}Mapper mapper) {
    this.redisTemplate = redisTemplate;
    this.mapper = mapper;
  }

  /**
   * Saves a ${entityName} to Redis.
   */
  public Mono<${entityName}> save(${entityName} entity) {
    ${entityName}Data data = mapper.toData(entity);
    String key = KEY_PREFIX + entity.getId();
    
    return redisTemplate.opsForValue()
        .set(key, data)
        .thenReturn(entity);
  }

  /**
   * Finds a ${entityName} by ID.
   */
  public Mono<${entityName}> findById(String id) {
    String key = KEY_PREFIX + id;
    
    return redisTemplate.opsForValue()
        .get(key)
        .map(mapper::toDomain);
  }

  /**
   * Finds all ${entityName} entities.
   */
  public Flux<${entityName}> findAll() {
    String pattern = KEY_PREFIX + "*";
    
    return redisTemplate.keys(pattern)
        .flatMap(key -> redisTemplate.opsForValue().get(key))
        .map(mapper::toDomain);
  }

  /**
   * Deletes a ${entityName} by ID.
   */
  public Mono<Boolean> deleteById(String id) {
    String key = KEY_PREFIX + id;
    
    return redisTemplate.delete(key)
        .map(count -> count > 0);
  }

  /**
   * Checks if a ${entityName} exists by ID.
   */
  public Mono<Boolean> existsById(String id) {
    String key = KEY_PREFIX + id;
    
    return redisTemplate.hasKey(key);
  }

<#if methods?has_content>
<#list methods as method>
  /**
   * ${method.name}
   */
  public ${method.returnType} ${method.name}(<#if method.parameters?? && method.parameters?has_content><#list method.parameters as param>${param.type} ${param.name}<#sep>, </#sep></#list></#if>) {
    // TODO: Implement custom method
    throw new UnsupportedOperationException("Not implemented yet");
  }

</#list>
</#if>
}
