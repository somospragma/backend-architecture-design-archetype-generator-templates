package ${packageName};

import ${modelPackage}.${entityName};
import ${packageName}.mapper.${entityName}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

/**
 * MongoDB adapter for ${entityName}.
 * Implements persistence operations using MongoDB.
 *
 * TODO: Create an output port interface (e.g., I${entityName}Gateway) in the domain layer
 * and have this adapter implement it to follow the hexagonal architecture pattern.
 */
@Component
@RequiredArgsConstructor
public class ${adapterName}Adapter {

    private final ${adapterName}Repository repository;
    private final ${entityName}EntityMapper mapper;

    /**
     * Saves an entity to MongoDB.
     */
    public ${entityName} save(${entityName} entity) {
        return mapper.toDomain(repository.save(mapper.toEntity(entity)));
    }

    /**
     * Finds an entity by ID from MongoDB.
     */
    public Optional<${entityName}> findById(String id) {
        return repository.findById(id)
                .map(mapper::toDomain);
    }

    /**
     * Finds all entities from MongoDB.
     */
    public List<${entityName}> findAll() {
        return repository.findAll().stream()
                .map(mapper::toDomain)
                .toList();
    }

    /**
     * Deletes an entity by ID from MongoDB.
     */
    public void deleteById(String id) {
        repository.deleteById(id);
    }

    /**
     * Checks if an entity exists in MongoDB.
     */
    public boolean existsById(String id) {
        return repository.existsById(id);
    }

    /**
     * Counts all entities in MongoDB.
     */
    public long count() {
        return repository.count();
    }

    /**
     * Deletes all entities from MongoDB.
     */
    public void deleteAll() {
        repository.deleteAll();
    }
}
