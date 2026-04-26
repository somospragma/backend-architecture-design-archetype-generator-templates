package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * Redis adapter for ${r"${entityName}"}.
 * Implements caching using Redis.
 */
@Component
@RequiredArgsConstructor
public class ${r"${adapterName}"}Adapter implements I${r"${entityName}"}Gateway {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ${r"${entityName}"}EntityMapper mapper;
    private static final String KEY_PREFIX = "${r"${entityName?lower_case}"}:";
    private static final long TTL_SECONDS = 3600; // 1 hour

    /**
     * Saves an entity to Redis cache.
     */
    public Object save(String id, Object entity) {
        String key = KEY_PREFIX + id;
        redisTemplate.opsForValue().set(key, entity, TTL_SECONDS, TimeUnit.SECONDS);
        return entity;
    }

    /**
     * Finds an entity by ID from Redis cache.
     */
    public Optional<Object> findById(String id) {
        String key = KEY_PREFIX + id;
        Object value = redisTemplate.opsForValue().get(key);
        return Optional.ofNullable(value);
    }

    /**
     * Finds all entities from Redis cache.
     */
    public List<Object> findAll() {
        String pattern = KEY_PREFIX + "*";
        var keys = redisTemplate.keys(pattern);

        if (keys == null || keys.isEmpty()) {
            return List.of();
        }

        return keys.stream()
                .map(key -> redisTemplate.opsForValue().get(key))
                .filter(value -> value != null)
                .collect(Collectors.toList());
    }

    /**
     * Deletes an entity by ID from Redis cache.
     */
    public boolean deleteById(String id) {
        String key = KEY_PREFIX + id;
        Boolean deleted = redisTemplate.delete(key);
        return Boolean.TRUE.equals(deleted);
    }

    /**
     * Checks if an entity exists in Redis cache.
     */
    public boolean existsById(String id) {
        String key = KEY_PREFIX + id;
        Boolean exists = redisTemplate.hasKey(key);
        return Boolean.TRUE.equals(exists);
    }

    /**
     * Deletes all entities matching the key pattern from Redis cache.
     */
    public void deleteAll() {
        String pattern = KEY_PREFIX + "*";
        var keys = redisTemplate.keys(pattern);

        if (keys != null && !keys.isEmpty()) {
            redisTemplate.delete(keys);
        }
    }
}
