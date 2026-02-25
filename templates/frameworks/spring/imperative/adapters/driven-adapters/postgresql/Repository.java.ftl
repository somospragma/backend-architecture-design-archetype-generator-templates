package ${packageName};

import ${packageName}.entity.${entityName}Entity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * JPA repository interface for ${entityName}Entity
 */
@Repository
public interface ${entityName}JpaRepository extends JpaRepository<${entityName}Entity, Long> {
    // Add custom query methods here if needed
}
