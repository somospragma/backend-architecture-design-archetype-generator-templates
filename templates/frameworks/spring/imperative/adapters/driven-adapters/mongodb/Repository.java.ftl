package ${packageName};

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

/**
 * MongoDB repository for ${entityName}.
 * Provides CRUD operations using Spring Data MongoDB.
 */
@Repository
public interface ${adapterName}MongoRepository extends MongoRepository<Object, String> {
  
  // Custom query methods can be added here
  // Example:
  // List<Object> findByName(String name);
  // Optional<Object> findByEmail(String email);
}
