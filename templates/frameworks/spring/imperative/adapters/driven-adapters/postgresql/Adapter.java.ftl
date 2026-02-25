package ${packageName};

import ${basePackage}.domain.model.${entityName};
import ${basePackage}.domain.port.out.${entityName}Repository;
import ${packageName}.entity.${entityName}Entity;
import ${packageName}.mapper.${entityName}Mapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * PostgreSQL adapter for ${entityName} using JPA
 */
@Repository
@RequiredArgsConstructor
public class ${adapterName}Adapter implements ${entityName}Repository {

    private final ${entityName}JpaRepository jpaRepository;
    private final ${entityName}Mapper mapper;

    @Override
    public ${entityName} save(${entityName} entity) {
        ${entityName}Entity entityToSave = mapper.toEntity(entity);
        ${entityName}Entity savedEntity = jpaRepository.save(entityToSave);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<${entityName}> findById(Long id) {
        return jpaRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public List<${entityName}> findAll() {
        return jpaRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteById(Long id) {
        jpaRepository.deleteById(id);
    }
}
