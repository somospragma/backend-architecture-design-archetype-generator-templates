package ${packageName}.infrastructure.entry-points.rest;

import ${packageName}.domain.port.in.${useCasePort};
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * REST Controller for ${controllerName}.
 * Handles HTTP requests and delegates to use cases.
 */
@RestController
@RequestMapping("${basePath}")
public class ${controllerName}Controller {

  private final ${useCasePort} ${useCasePort?uncap_first};

  public ${controllerName}Controller(${useCasePort} ${useCasePort?uncap_first}) {
    this.${useCasePort?uncap_first} = ${useCasePort?uncap_first};
  }

  @PostMapping
  public Mono<ResponseEntity<${responseType}>> create(@RequestBody ${requestType} request) {
    return ${useCasePort?uncap_first}.execute(request)
        .map(result -> ResponseEntity.status(HttpStatus.CREATED).body(result))
        .defaultIfEmpty(ResponseEntity.badRequest().build());
  }

  @GetMapping("/{id}")
  public Mono<ResponseEntity<${responseType}>> getById(@PathVariable String id) {
    return ${useCasePort?uncap_first}.findById(id)
        .map(ResponseEntity::ok)
        .defaultIfEmpty(ResponseEntity.notFound().build());
  }

  @GetMapping
  public Flux<${responseType}> getAll() {
    return ${useCasePort?uncap_first}.findAll();
  }

  @PutMapping("/{id}")
  public Mono<ResponseEntity<${responseType}>> update(
      @PathVariable String id,
      @RequestBody ${requestType} request) {
    return ${useCasePort?uncap_first}.update(id, request)
        .map(ResponseEntity::ok)
        .defaultIfEmpty(ResponseEntity.notFound().build());
  }

  @DeleteMapping("/{id}")
  public Mono<ResponseEntity<Void>> delete(@PathVariable String id) {
    return ${useCasePort?uncap_first}.delete(id)
        .then(Mono.just(ResponseEntity.noContent().<Void>build()))
        .defaultIfEmpty(ResponseEntity.notFound().build());
  }
}
