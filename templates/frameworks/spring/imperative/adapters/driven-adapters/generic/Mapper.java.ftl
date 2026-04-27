package ${packageName};

import ${modelPackage}.${entityName};
import ${entityPackage}.${entityName}Entity;
import org.mapstruct.Mapper;

/**
 * MapStruct mapper for ${entityName}.
 * Converts between domain model and data entity.
 */
@Mapper(componentModel = "spring")
public interface ${entityName}EntityMapper {
    ${entityName} toDomain(${entityName}Entity entity);
    ${entityName}Entity toEntity(${entityName} domain);
}
