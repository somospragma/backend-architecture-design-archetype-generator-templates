package ${packageName}.infrastructure.entry-points.rest.mapper;

import ${packageName}.domain.model.${entityName};
import ${packageName}.infrastructure.entry-points.rest.dto.${controllerName}Request;
import ${packageName}.infrastructure.entry-points.rest.dto.${controllerName}Response;
import org.springframework.stereotype.Component;

/**
 * Mapper between DTOs and domain entities for ${controllerName}.
 */
@Component
public class ${controllerName}DtoMapper {

  public ${entityName} toDomain(${controllerName}Request request) {
    // TODO: Implement mapping from request to domain entity
    return ${entityName}.builder()
        .id(request.id())
        .name(request.name())
        .build();
  }

  public ${controllerName}Response toResponse(${entityName} entity) {
    // TODO: Implement mapping from domain entity to response
    return new ${controllerName}Response(
        entity.getId(),
        entity.getName(),
        entity.getCreatedAt() != null ? entity.getCreatedAt().toString() : null
    );
  }
}
