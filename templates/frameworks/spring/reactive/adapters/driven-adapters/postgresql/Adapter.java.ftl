package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.model.${r"${entityName}"};
import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.entity.${r"${entityName}"}Entity;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * PostgreSQL adapter for ${r"${entityName}"} using R2DBC
 */
@Repository
@RequiredArgsConstructor
public class ${r"${adapterName}"}Adapter implements I${r"${entityName}"}Gateway {

    private final ${r"${entityName}"}R2dbcRepository r2dbcRepository;
    private final ${r"${entityName}"}EntityMapper mapper;

    @Override
    public Mono<${r"${entityName}"}> save(${r"${entityName}"} entity) {
        return Mono.just(entity)
                .map(mapper::toEntity)
                .flatMap(r2dbcRepository::save)
                .map(mapper::toDomain);
    }

    @Override
    public Mono<${r"${entityName}"}> findById(Long id) {
        return r2dbcRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public Flux<${r"${entityName}"}> findAll() {
        return r2dbcRepository.findAll()
                .map(mapper::toDomain);
    }

    @Override
    public Mono<Void> deleteById(Long id) {
        return r2dbcRepository.deleteById(id);
    }
}
