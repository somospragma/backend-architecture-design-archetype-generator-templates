package ${packageName}.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

import ${packageName}.entity.${entityName}Data;

/**
 * Mapper for ${entityName} between domain and data models.
 * Uses MapStruct for automatic mapping.
 */
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface ${entityName}Mapper {

  /**
   * Converts domain entity to data entity.
   */
  ${entityName}Data toData(${entityName} domain);

  /**
   * Converts data entity to domain entity.
   */
  ${entityName} toDomain(${entityName}Data data);
}
