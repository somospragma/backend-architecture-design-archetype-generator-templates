package ${packageName};

<#if needsUUID>
import java.util.UUID;
</#if>
<#if needsLocalDateTime>
import java.time.LocalDateTime;
</#if>
<#if needsLocalDate>
import java.time.LocalDate;
</#if>
<#if needsBigDecimal>
import java.math.BigDecimal;
</#if>

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Domain entity: ${entityName}
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ${entityName} {

<#if hasId>
  private ${idType} id;
</#if>

<#list fields as field>
  private ${field.type} ${field.name};
</#list>
}
