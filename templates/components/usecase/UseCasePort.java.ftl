package ${packageName};

/**
 * Use case: ${useCaseName}
 * Port interface defining the contract for this use case.
 */
public interface ${useCaseName}UseCase {

<#list methods as method>
  /**
   * ${method.name}
<#if method.parameters?? && method.parameters?has_content>
<#list method.parameters as param>
   * @param ${param.name} ${param.type}
</#list>
</#if>
   * @return ${method.returnType}
   */
  ${method.returnType} ${method.name}(<#if method.parameters?? && method.parameters?has_content><#list method.parameters as param>${param.type} ${param.name}<#sep>, </#sep></#list></#if>);

</#list>
}
