package ${packageName};

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * Input port for ${useCaseName}.
 * Defines the contract for this use case.
 */
public interface ${useCaseName}UseCase {

  /**
   * Executes the main use case logic.
   */
  Mono<Object> execute(Object input);

  /**
   * Finds an entity by ID.
   */
  Mono<Object> findById(String id);

  /**
   * Finds all entities.
   */
  Flux<Object> findAll();

  /**
   * Updates an entity.
   */
  Mono<Object> update(String id, Object input);

  /**
   * Deletes an entity by ID.
   */
  Mono<Void> delete(String id);
}
