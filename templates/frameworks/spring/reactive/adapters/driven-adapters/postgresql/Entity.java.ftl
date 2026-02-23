package ${packageName}.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * PostgreSQL table entity for ${entityName}
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table("${entityName?lower_case}s")
public class ${entityName}Entity {
    
    @Id
    private Long id;
    
    // Add your entity fields here
    
}
