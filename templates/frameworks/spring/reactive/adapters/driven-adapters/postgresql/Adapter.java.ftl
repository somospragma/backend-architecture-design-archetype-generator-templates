package ${packageName};

import ${basePackage}.domain.model.${entityName};
import ${basePackage}.domain.port.out.${entityName}Repository;
import ${packageName}.entity.${entityName}Entity;
import ${packageName}.mapper.${entityName}Mapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * PostgreSQL adapter for ${entityName} using R2DBC
 */
@Repository
@RequiredArgsConstructor
public class ${adapterName}Adapter implements ${entityName}Repository {

    private final ${entityName}R2dbcRepository r2dbcRepository;
    private final ${entityName}Mapper mapper;

    @Override
    public Mono<${entityName}> save(${entityName} entity) {
        return Mono.just(entity)
                .map(mapper::toEntity)
                .flatMap(r2dbcRepository::save)
                .map(mapper::toDomain);
    }

    @Override
    public Mono<${entityName}> findById(Long id) {
        return r2dbcRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public Flux<${entityName}> findAll() {
        return r2dbcRepository.findAll()
                .map(mapper::toDomain);
    }

    @Override
    public Mono<Void> deleteById(Long id) {
        return r2dbcRepository.deleteById(id);
    }
}
