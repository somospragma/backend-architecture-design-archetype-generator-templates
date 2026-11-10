package ${implPackage};

<#if inputPort!true>
import ${packageName}.I${useCaseName}UseCase;
</#if>

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import lombok.RequiredArgsConstructor;

/**
 * Use case implementation for ${useCaseName}.
 * Contains the business logic for this use case.
 *
 * Note: This class is automatically registered as a Spring bean
 * through component scanning configured in UseCasesConfig.
 */
@RequiredArgsConstructor
public class ${useCaseName}UseCase<#if inputPort!true> implements I${useCaseName}UseCase</#if> {

  // TODO: Inject required ports (gateways, services, etc.)
  // Example:
  // private final I${r"${entityName}"}Gateway gateway;

  /**
   * Executes the main use case logic.
   */
<#if inputPort!true>
  @Override
</#if>
  public Mono<Object> execute(Object input) {
    // TODO: Implement business logic
    return Mono.just(input);
  }

  /**
   * Finds an entity by ID.
   */
<#if inputPort!true>
  @Override
</#if>
  public Mono<Object> findById(String id) {
    // TODO: Implement find by id logic
    return Mono.empty();
  }

  /**
   * Finds all entities.
   */
<#if inputPort!true>
  @Override
</#if>
  public Flux<Object> findAll() {
    // TODO: Implement find all logic
    return Flux.empty();
  }

  /**
   * Updates an entity.
   */
<#if inputPort!true>
  @Override
</#if>
  public Mono<Object> update(String id, Object input) {
    // TODO: Implement update logic
    return Mono.just(input);
  }

  /**
   * Deletes an entity by ID.
   */
<#if inputPort!true>
  @Override
</#if>
  public Mono<Void> delete(String id) {
    // TODO: Implement delete logic
    return Mono.empty();
  }
}
