package ${packageName};

import ${modelPackage}.${entityName};
import ${packageName}.entity.${entityName}Entity;
import ${packageName}.mapper.${entityName}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * PostgreSQL adapter for ${entityName} using R2DBC
 *
 * TODO: Create an output port interface (e.g., I${entityName}Gateway) in the domain layer
 * and have this adapter implement it to follow the hexagonal architecture pattern.
 */
@Repository
@RequiredArgsConstructor
public class ${adapterName}Adapter {

    private final ${adapterName}Repository r2dbcRepository;
    private final ${entityName}EntityMapper mapper;

    public Mono<${entityName}> save(${entityName} entity) {
        return Mono.just(entity)
                .map(mapper::toEntity)
                .flatMap(r2dbcRepository::save)
                .map(mapper::toDomain);
    }

    public Mono<${entityName}> findById(Long id) {
        return r2dbcRepository.findById(id)
                .map(mapper::toDomain);
    }

    public Flux<${entityName}> findAll() {
        return r2dbcRepository.findAll()
                .map(mapper::toDomain);
    }

    public Mono<Void> deleteById(Long id) {
        return r2dbcRepository.deleteById(id);
    }
}
