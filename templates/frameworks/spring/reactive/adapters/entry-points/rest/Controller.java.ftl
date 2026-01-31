package ${packageName};

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * REST Controller for ${controllerName}.
 * Handles HTTP requests and delegates to use cases.
 * 
 * Note: @RestController and @RequestMapping are required for Spring Web MVC/WebFlux
 * to recognize this as an HTTP endpoint. These are infrastructure concerns that
 * belong in the entry-points layer.
 */
@RestController
@RequestMapping("/api/${controllerName?lower_case}s")
public class ${controllerName}Controller {

  // TODO: Inject use case port
  // private final ${controllerName}UseCase ${controllerName?uncap_first}UseCase;

  public ${controllerName}Controller() {
    // TODO: Initialize with use case
  }

  @PostMapping
  public Mono<ResponseEntity<Object>> create(@RequestBody Object request) {
    // TODO: Implement create logic
    return Mono.just(ResponseEntity.status(HttpStatus.CREATED).body(request));
  }

  @GetMapping("/{id}")
  public Mono<ResponseEntity<Object>> getById(@PathVariable String id) {
    // TODO: Implement get by id logic
    return Mono.just(ResponseEntity.ok().build());
  }

  @GetMapping
  public Flux<Object> getAll() {
    // TODO: Implement get all logic
    return Flux.empty();
  }

  @PutMapping("/{id}")
  public Mono<ResponseEntity<Object>> update(
      @PathVariable String id,
      @RequestBody Object request) {
    // TODO: Implement update logic
    return Mono.just(ResponseEntity.ok(request));
  }

  @DeleteMapping("/{id}")
  public Mono<ResponseEntity<Void>> delete(@PathVariable String id) {
    // TODO: Implement delete logic
    return Mono.just(ResponseEntity.noContent().build());
  }
}
