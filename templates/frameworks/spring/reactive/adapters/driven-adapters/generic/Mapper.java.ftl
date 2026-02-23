package ${packageName}.mapper;

import org.springframework.stereotype.Component;

/**
 * Mapper for ${entityName}.
 * Converts between domain entities and data entities.
 */
@Component
public class ${entityName}Mapper {

  /**
   * Converts domain entity to data entity.
   */
  public Object toData(Object domainEntity) {
    // TODO: Implement mapping logic
    return domainEntity;
  }

  /**
   * Converts data entity to domain entity.
   */
  public Object toDomain(Object dataEntity) {
    // TODO: Implement mapping logic
    return dataEntity;
  }
}
