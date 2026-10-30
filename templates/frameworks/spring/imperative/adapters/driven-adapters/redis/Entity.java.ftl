package ${packageName};

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * Redis entity for ${entityName}.
 * Represents the cached data model stored in Redis.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ${entityName}Entity implements Serializable {

    private String id;

    // Add your entity fields here

}
