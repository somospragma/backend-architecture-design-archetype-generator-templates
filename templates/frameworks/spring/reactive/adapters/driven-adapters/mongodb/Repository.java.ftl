package ${packageName};

import ${packageName}.entity.${entityName}Entity;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;

/**
 * Reactive MongoDB repository for ${entityName}.
 * Provides CRUD operations using Spring Data MongoDB Reactive.
 */
@Repository
public interface ${adapterName}Repository extends ReactiveMongoRepository<${entityName}Entity, String> {

  // Custom query methods can be added here
  // Example:
  // Flux<${entityName}Entity> findByName(String name);
}
