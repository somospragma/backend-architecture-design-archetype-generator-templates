package ${packageName}.infrastructure.driven-adapters.redis.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

/**
 * Redis configuration for ${adapterName}.
 * Configures RedisTemplate with Lettuce connection factory.
 */
@Configuration
public class ${adapterName}RedisConfig {

  @Bean
  public RedisConnectionFactory redisConnectionFactory() {
    return new LettuceConnectionFactory();
  }

  @Bean
  public RedisTemplate<String, Object> redisTemplate(
      RedisConnectionFactory connectionFactory) {
    
    RedisTemplate<String, Object> template = new RedisTemplate<>();
    template.setConnectionFactory(connectionFactory);
    
    StringRedisSerializer keySerializer = new StringRedisSerializer();
    Jackson2JsonRedisSerializer<Object> valueSerializer = 
        new Jackson2JsonRedisSerializer<>(Object.class);

    template.setKeySerializer(keySerializer);
    template.setValueSerializer(valueSerializer);
    template.setHashKeySerializer(keySerializer);
    template.setHashValueSerializer(valueSerializer);
    
    template.afterPropertiesSet();
    
    return template;
  }
}
