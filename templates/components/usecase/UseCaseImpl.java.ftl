package ${implPackage};

import ${packageName}.${useCaseName}UseCase;

/**
 * Implementation of ${useCaseName}UseCase.
 * Contains the business logic for this use case.
 */
public class ${useCaseName}UseCaseImpl implements ${useCaseName}UseCase {

  // TODO: Inject required dependencies (repositories, services, etc.)
  // Example:
  // private final SomeRepository repository;
  //
  // public ${useCaseName}UseCaseImpl(SomeRepository repository) {
  //   this.repository = repository;
  // }

<#list methods as method>
  @Override
  public ${method.returnType} ${method.name}(<#if method.parameters?? && method.parameters?has_content><#list method.parameters as param>${param.type} ${param.name}<#sep>, </#sep></#list></#if>) {
    // TODO: Implement business logic
    throw new UnsupportedOperationException("Not implemented yet");
  }

</#list>
}
