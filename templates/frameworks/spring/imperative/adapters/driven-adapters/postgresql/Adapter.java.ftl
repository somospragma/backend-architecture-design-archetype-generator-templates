package ${packageName};

import ${modelPackage}.${entityName};
import ${packageName}.entity.${entityName}Entity;
import ${packageName}.mapper.${entityName}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * PostgreSQL adapter for ${entityName} using JPA
 *
 * TODO: Create an output port interface (e.g., I${entityName}Gateway) in the domain layer
 * and have this adapter implement it to follow the hexagonal architecture pattern.
 */
@Repository
@RequiredArgsConstructor
public class ${adapterName}Adapter {

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
