package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.model.${r"${entityName}"};
import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.entity.${r"${entityName}"}Entity;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * PostgreSQL adapter for ${r"${entityName}"} using JPA
 */
@Repository
@RequiredArgsConstructor
public class ${r"${adapterName}"}Adapter implements I${r"${entityName}"}Gateway {

    private final ${r"${entityName}"}JpaRepository jpaRepository;
    private final ${r"${entityName}"}EntityMapper mapper;

    @Override
    public ${r"${entityName}"} save(${r"${entityName}"} entity) {
        ${r"${entityName}"}Entity entityToSave = mapper.toEntity(entity);
        ${r"${entityName}"}Entity savedEntity = jpaRepository.save(entityToSave);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<${r"${entityName}"}> findById(Long id) {
        return jpaRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public List<${r"${entityName}"}> findAll() {
        return jpaRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteById(Long id) {
        jpaRepository.deleteById(id);
    }
}
