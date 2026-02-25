package ${packageName};

import java.util.List;
import java.util.Optional;

/**
 * Input port for ${useCaseName}.
 * Defines the contract for this use case.
 */
public interface ${useCaseName}UseCase {

  /**
   * Executes the main use case logic.
   */
  Object execute(Object input);

  /**
   * Finds an entity by ID.
   */
  Optional<Object> findById(String id);

  /**
   * Finds all entities.
   */
  List<Object> findAll();

  /**
   * Updates an entity.
   */
  Object update(String id, Object input);

  /**
   * Deletes an entity by ID.
   */
  void delete(String id);
}
