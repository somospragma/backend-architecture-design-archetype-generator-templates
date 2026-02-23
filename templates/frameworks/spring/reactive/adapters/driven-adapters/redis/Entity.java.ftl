package ${basePackage}.infrastructure.adapter.out.${adapterName?lower_case}.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Redis hash entity for ${entityName}
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@RedisHash("${entityName?lower_case}")
public class ${entityName}Entity {
    
    @Id
    private String id;
    
    // Add your entity fields here
    
}
