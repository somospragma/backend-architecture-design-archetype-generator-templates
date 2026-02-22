package ${packageName}.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * MongoDB document entity for ${entityName}
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "${entityName?lower_case}s")
public class ${entityName}Entity {
    
    @Id
    private String id;
    
    // Add your entity fields here
    
}
