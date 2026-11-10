package ${packageName};

import ${modelPackage}.${entityName};
import ${entityPackage}.${entityName}Entity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

/**
 * MapStruct mapper for converting between ${entityName} domain model and ${entityName}Entity JPA entity.
 */
@Mapper(componentModel = "spring")
public interface ${entityName}EntityMapper {

    /**
     * Converts a domain model to a JPA entity.
     */
    ${entityName}Entity toEntity(${entityName} domain);

    /**
     * Converts a JPA entity to a domain model.
     */
    ${entityName} toDomain(${entityName}Entity entity);
}
