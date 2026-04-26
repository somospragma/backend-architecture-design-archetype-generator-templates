package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.model.${r"${entityName}"};
import ${r"${basePackage}"}.domain.ports.I${r"${entityName}"}Gateway;
import ${r"${packageName}"}.mapper.${r"${entityName}"}EntityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

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
    public ${r"${entityName}"} save(${r"${entityName}"} entity) {
        return mapper.toDomain(repository.save(mapper.toEntity(entity)));
    }

    /**
     * Finds an entity by ID from MongoDB.
     */
    public Optional<${r"${entityName}"}> findById(String id) {
        return repository.findById(id)
                .map(mapper::toDomain);
    }

    /**
     * Finds all entities from MongoDB.
     */
    public List<${r"${entityName}"}> findAll() {
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
