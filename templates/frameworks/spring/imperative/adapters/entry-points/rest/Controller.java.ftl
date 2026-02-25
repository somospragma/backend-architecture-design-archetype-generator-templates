package ${packageName};

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.validation.annotation.Validated;

import java.util.List;

/**
 * REST Controller for ${controllerName}.
 * Handles HTTP requests and delegates to use cases.
 * 
 * Note: @RestController and @RequestMapping are required for Spring Web MVC
 * to recognize this as an HTTP endpoint. These are infrastructure concerns that
 * belong in the entry-points layer.
 */
@RestController
@RequestMapping("${basePath!'/api/' + controllerName?lower_case + 's'}")
@Validated
public class ${controllerName}Controller {

  // TODO: Inject use case port
  // private final ${controllerName}UseCase ${controllerName?uncap_first}UseCase;

  public ${controllerName}Controller() {
    // TODO: Initialize with use case
  }

  @PostMapping
  public ResponseEntity<Object> create(@RequestBody @Validated Object request) {
    // TODO: Implement create logic
    return ResponseEntity.status(HttpStatus.CREATED).body(request);
  }

  @GetMapping("/{id}")
  public ResponseEntity<Object> getById(@PathVariable String id) {
    // TODO: Implement get by id logic
    return ResponseEntity.ok().build();
  }

  @GetMapping
  public ResponseEntity<List<Object>> getAll() {
    // TODO: Implement get all logic
    return ResponseEntity.ok(List.of());
  }

  @PutMapping("/{id}")
  public ResponseEntity<Object> update(
      @PathVariable String id,
      @RequestBody @Validated Object request) {
    // TODO: Implement update logic
    return ResponseEntity.ok(request);
  }

  @PatchMapping("/{id}")
  public ResponseEntity<Object> patch(
      @PathVariable String id,
      @RequestBody Object request) {
    // TODO: Implement patch logic
    return ResponseEntity.ok(request);
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> delete(@PathVariable String id) {
    // TODO: Implement delete logic
    return ResponseEntity.noContent().build();
  }
}
