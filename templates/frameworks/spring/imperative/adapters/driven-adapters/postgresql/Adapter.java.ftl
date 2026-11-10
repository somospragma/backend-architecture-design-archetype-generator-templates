package ${packageName};

import ${portsPackage}.I${entityName}Gateway;
import ${modelPackage}.${entityName};
import ${packageName}.entity.${entityName}Entity;
import ${packageName}.mapper.${entityName}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * PostgreSQL adapter for ${entityName} using JPA.
 * Implements the I${entityName}Gateway port from the domain layer.
 */
@Repository
@RequiredArgsConstructor
public class ${adapterName}Adapter implements I${entityName}Gateway {

    private final ${adapterName}Repository jpaRepository;
    private final ${entityName}EntityMapper mapper;

    public ${entityName} save(${entityName} entity) {
        ${entityName}Entity entityToSave = mapper.toEntity(entity);
        ${entityName}Entity savedEntity = jpaRepository.save(entityToSave);
        return mapper.toDomain(savedEntity);
    }

    public Optional<${entityName}> findById(Long id) {
        return jpaRepository.findById(id)
                .map(mapper::toDomain);
    }

    public List<${entityName}> findAll() {
        return jpaRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        jpaRepository.deleteById(id);
    }
}
