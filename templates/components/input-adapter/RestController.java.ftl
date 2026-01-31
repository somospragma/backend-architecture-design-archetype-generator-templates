package ${packageName};

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

/**
 * REST Controller for ${controllerName}.
 * Handles HTTP requests and delegates to use cases.
 */
@RestController
@RequestMapping("/api")
public class ${controllerName}Controller {

  private final ${useCaseName} ${useCaseName?uncap_first};

  public ${controllerName}Controller(${useCaseName} ${useCaseName?uncap_first}) {
    this.${useCaseName?uncap_first} = ${useCaseName?uncap_first};
  }

<#list endpoints as endpoint>
  /**
   * ${endpoint.method} ${endpoint.path}
   */
  @${endpoint.method?lower_case?cap_first}Mapping("${endpoint.path}")
  public Mono<ResponseEntity<${endpoint.returnType}>> ${endpoint.useCaseMethod}(
<#if endpoint.parameters?has_content>
<#list endpoint.parameters as param>
      @<#if param.paramType == "PATH">PathVariable<#elseif param.paramType == "BODY">RequestBody<#elseif param.paramType == "QUERY">RequestParam</#if> ${param.type} ${param.name}<#sep>,
</#sep>
</#list>
</#if>) {
    return ${useCaseName?uncap_first}.${endpoint.useCaseMethod}(<#if endpoint.parameters?has_content><#list endpoint.parameters as param>${param.name}<#sep>, </#sep></#list></#if>)
        .map(result -> ResponseEntity.ok(result))
        .defaultIfEmpty(ResponseEntity.notFound().build());
  }

</#list>
}
