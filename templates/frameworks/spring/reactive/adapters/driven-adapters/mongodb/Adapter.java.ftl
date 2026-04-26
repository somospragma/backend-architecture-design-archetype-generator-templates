package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.model.${r"${entityName}"};
import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * MongoDB adapter for ${r"${entityName}"}.
 * Implements persistence operations using MongoDB.
 */
@Component
@RequiredArgsConstructor
public class ${r"${adapterName}"}Adapter implements I${r"${entityName}"}Gateway {

    private final ${r"${adapterName}"}MongoRepository repository;
    private final ${r"${entityName}"}EntityMapper mapper;

    /**
     * Saves an entity to MongoDB.
     */
    public Mono<${r"${entityName}"}> save(${r"${entityName}"} entity) {
        return Mono.just(entity)
                .map(mapper::toEntity)
                .flatMap(repository::save)
                .map(mapper::toDomain);
    }

    /**
     * Finds an entity by ID from MongoDB.
     */
    public Mono<${r"${entityName}"}> findById(String id) {
        return repository.findById(id)
                .map(mapper::toDomain);
    }

    /**
     * Finds all entities from MongoDB.
     */
    public Flux<${r"${entityName}"}> findAll() {
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
