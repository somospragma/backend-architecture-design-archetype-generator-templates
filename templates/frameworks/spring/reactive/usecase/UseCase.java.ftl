package ${packageName}.domain.usecase;

import ${packageName}.domain.model.${entityName};
import ${packageName}.domain.port.in.${useCasePort};
import ${packageName}.domain.port.out.${repositoryPort};
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * Use case implementation for ${useCaseName}.
 * Contains the business logic for this use case.
 */
@Service
public class ${useCaseName}UseCase implements ${useCasePort} {

  private final ${repositoryPort} ${repositoryPort?uncap_first};

  public ${useCaseName}UseCase(${repositoryPort} ${repositoryPort?uncap_first}) {
    this.${repositoryPort?uncap_first} = ${repositoryPort?uncap_first};
  }

  @Override
  public Mono<${entityName}> execute(${entityName} entity) {
    // TODO: Implement business logic
    return ${repositoryPort?uncap_first}.save(entity);
  }

  @Override
  public Mono<${entityName}> findById(String id) {
    return ${repositoryPort?uncap_first}.findById(id);
  }

  @Override
  public Flux<${entityName}> findAll() {
    return ${repositoryPort?uncap_first}.findAll();
  }

  @Override
  public Mono<${entityName}> update(String id, ${entityName} entity) {
    return ${repositoryPort?uncap_first}.findById(id)
        .flatMap(existing -> ${repositoryPort?uncap_first}.save(entity));
  }

  @Override
  public Mono<Void> delete(String id) {
    return ${repositoryPort?uncap_first}.deleteById(id)
        .then();
  }
}
