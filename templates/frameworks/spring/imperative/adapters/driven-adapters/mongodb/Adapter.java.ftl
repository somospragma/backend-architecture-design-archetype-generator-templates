package ${packageName};

import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Optional;

/**
 * MongoDB adapter for ${entityName}.
 * Implements persistence operations using MongoDB.
 * 
 * Note: This class is automatically registered as a Spring bean
 * through component scanning configured in BeanConfiguration.
 */
@Component
public class ${adapterName}Adapter {

  private final ${adapterName}MongoRepository repository;

  public ${adapterName}Adapter(${adapterName}MongoRepository repository) {
    this.repository = repository;
  }

  /**
   * Saves an entity to MongoDB.
   */
  public Object save(Object entity) {
    return repository.save(entity);
  }

  /**
   * Finds an entity by ID from MongoDB.
   */
  public Optional<Object> findById(String id) {
    return repository.findById(id);
  }

  /**
   * Finds all entities from MongoDB.
   */
  public List<Object> findAll() {
    return repository.findAll();
  }

  /**
   * Deletes an entity by ID from MongoDB.
   */
  public void deleteById(String id) {
    repository.deleteById(id);
  }

  /**
   * Checks if an entity exists in MongoDB.
   */
  public boolean existsById(String id) {
    return repository.existsById(id);
  }

  /**
   * Counts all entities in MongoDB.
   */
  public long count() {
    return repository.count();
  }

  /**
   * Deletes all entities from MongoDB.
   */
  public void deleteAll() {
    repository.deleteAll();
  }
}
