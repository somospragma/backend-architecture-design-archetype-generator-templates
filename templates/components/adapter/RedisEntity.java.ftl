package ${packageName}.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Redis data entity for ${entityName}.
 * Represents the persistence model in Redis.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@RedisHash("${entityName?lower_case}")
public class ${entityName}Data {

  @Id
  private String id;

  // TODO: Add fields matching the domain entity
  // Example:
  // private String name;
  // private String email;
  // private LocalDateTime createdAt;
}
