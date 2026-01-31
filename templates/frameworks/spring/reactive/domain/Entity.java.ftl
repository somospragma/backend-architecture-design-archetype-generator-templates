package ${packageName};

<#if needsUUID>
import java.util.UUID;
</#if>
<#if needsLocalDateTime>
import java.time.LocalDateTime;
</#if>

/**
 * Domain entity: ${entityName}
 */
public class ${entityName} {

<#if hasId>
  private ${idType} id;
</#if>

<#list fields as field>
  private ${field.type} ${field.name};
</#list>

  public ${entityName}() {
  }

<#if hasId>
  public ${idType} getId() {
    return id;
  }

  public void setId(${idType} id) {
    this.id = id;
  }
</#if>

<#list fields as field>
  public ${field.type} get${field.name?cap_first}() {
    return ${field.name};
  }

  public void set${field.name?cap_first}(${field.type} ${field.name}) {
    this.${field.name} = ${field.name};
  }

</#list>
}
