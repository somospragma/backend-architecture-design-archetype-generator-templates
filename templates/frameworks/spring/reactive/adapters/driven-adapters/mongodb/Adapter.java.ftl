package ${packageName};

import ${portsPackage}.I${entityName}Gateway;
import ${modelPackage}.${entityName};
import ${packageName}.mapper.${entityName}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * MongoDB adapter for ${entityName}.
 * Implements persistence operations using MongoDB.
 * Implements the I${entityName}Gateway port from the domain layer.
 */
@Component
@RequiredArgsConstructor
public class ${adapterName}Adapter implements I${entityName}Gateway {

    private final ${adapterName}Repository repository;
    private final ${entityName}EntityMapper mapper;

    /**
     * Saves an entity to MongoDB.
     */
    public Mono<${entityName}> save(${entityName} entity) {
        return Mono.just(entity)
                .map(mapper::toEntity)
                .flatMap(repository::save)
                .map(mapper::toDomain);
    }

    /**
     * Finds an entity by ID from MongoDB.
     */
    public Mono<${entityName}> findById(String id) {
        return repository.findById(id)
                .map(mapper::toDomain);
    }

    /**
     * Finds all entities from MongoDB.
     */
    public Flux<${entityName}> findAll() {
        return repository.findAll()
                .map(mapper::toDomain);
    }

    /**
     * Deletes an entity by ID from MongoDB.
     */
    public Mono<Void> deleteById(String id) {
        return repository.deleteById(id);
    }

    /**
     * Checks if an entity exists in MongoDB.
     */
    public Mono<Boolean> existsById(String id) {
        return repository.existsById(id);
    }

    /**
     * Counts all entities in MongoDB.
     */
    public Mono<Long> count() {
        return repository.count();
    }

    /**
     * Deletes all entities from MongoDB.
     */
    public Mono<Void> deleteAll() {
        return repository.deleteAll();
    }
}
