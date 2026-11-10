package ${packageName};

import ${packageName}.entity.${entityName}Entity;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

/**
 * MongoDB repository for ${entityName}.
 * Provides CRUD operations using Spring Data MongoDB.
 */
@Repository
public interface ${adapterName}Repository extends MongoRepository<${entityName}Entity, String> {
  
  // Custom query methods can be added here
  // Example:
  // List<${entityName}Entity> findByName(String name);
  // Optional<${entityName}Entity> findByEmail(String email);
}
