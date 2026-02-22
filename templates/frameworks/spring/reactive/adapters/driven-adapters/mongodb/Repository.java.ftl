package ${packageName};

import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;

/**
 * Reactive MongoDB repository for ${entityName}.
 * Provides CRUD operations using Spring Data MongoDB Reactive.
 */
@Repository
public interface ${adapterName}MongoRepository extends ReactiveMongoRepository<Object, String> {
  
  // Custom query methods can be added here
  // Example:
  // Flux<Object> findByName(String name);
  // Mono<Object> findByEmail(String email);
}
