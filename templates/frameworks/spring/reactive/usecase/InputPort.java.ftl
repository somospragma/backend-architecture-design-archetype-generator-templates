package ${packageName}.domain.port.in;

import ${packageName}.domain.model.${entityName};
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * Input port for ${useCaseName}.
 * Defines the contract for this use case.
 */
public interface ${useCasePort} {

  /**
   * Executes the main use case logic.
   */
  Mono<${entityName}> execute(${entityName} entity);

  /**
   * Finds an entity by ID.
   */
  Mono<${entityName}> findById(String id);

  /**
   * Finds all entities.
   */
  Flux<${entityName}> findAll();

  /**
   * Updates an entity.
   */
  Mono<${entityName}> update(String id, ${entityName} entity);

  /**
   * Deletes an entity by ID.
   */
  Mono<Void> delete(String id);
}
