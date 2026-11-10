package ${packageName};

import ${packageName}.entity.${entityName}Entity;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;

/**
 * R2DBC repository interface for ${entityName}Entity
 */
@Repository
public interface ${adapterName}Repository extends ReactiveCrudRepository<${entityName}Entity, Long> {
    // Add custom query methods here if needed
}
