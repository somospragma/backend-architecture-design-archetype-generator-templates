package ${implPackage};

import ${packageName}.I${useCaseName}UseCase;

import java.util.List;
import java.util.Optional;

import lombok.RequiredArgsConstructor;

/**
 * Use case implementation for ${useCaseName}.
 * Contains the business logic for this use case.
 *
 * Note: This class is automatically registered as a Spring bean
 * through component scanning configured in UseCasesConfig.
 */
@RequiredArgsConstructor
public class ${useCaseName}UseCase implements I${useCaseName}UseCase {

  // TODO: Inject required ports (gateways, services, etc.)
  // Example:
  // private final I${r"${entityName}"}Gateway gateway;

  /**
   * Executes the main use case logic.
   */
  @Override
  public Object execute(Object input) {
    // TODO: Implement business logic
    return input;
  }

  /**
   * Finds an entity by ID.
   */
  @Override
  public Optional<Object> findById(String id) {
    // TODO: Implement find by id logic
    return Optional.empty();
  }

  /**
   * Finds all entities.
   */
  @Override
  public List<Object> findAll() {
    // TODO: Implement find all logic
    return List.of();
  }

  /**
   * Updates an entity.
   */
  @Override
  public Object update(String id, Object input) {
    // TODO: Implement update logic
    return input;
  }

  /**
   * Deletes an entity by ID.
   */
  @Override
  public void delete(String id) {
    // TODO: Implement delete logic
  }
}
