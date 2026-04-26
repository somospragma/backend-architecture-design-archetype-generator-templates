package ${r"${packageName}"};

import ${r"${basePackage}"}.domain.ports.I${r"${controllerName}"}UseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST Controller for ${r"${controllerName}"}.
 * Handles HTTP requests and delegates to use cases.
 */
@Tag(name = "${r"${controllerName}"}", description = "${r"${controllerName}"} API")
@RestController
@RequestMapping("/api/v1/${r"${controllerName?lower_case}"}s")
@Validated
@RequiredArgsConstructor
public class ${r"${controllerName}"}Controller {

    private final I${r"${controllerName}"}UseCase ${r"${controllerName?uncap_first}"}UseCase;

    @Operation(summary = "Create ${r"${controllerName}"}")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request")
    })
    @PostMapping
    public ResponseEntity<${r"${controllerName}"}Response> create(
            @RequestBody @Valid Create${r"${controllerName}"}Request request) {
        // TODO: Implement create logic
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @Operation(summary = "Get ${r"${controllerName}"} by ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Found successfully"),
        @ApiResponse(responseCode = "404", description = "Not found")
    })
    @GetMapping("/{id}")
    public ResponseEntity<${r"${controllerName}"}Response> getById(@PathVariable String id) {
        // TODO: Implement get by id logic
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Get all ${r"${controllerName}"}s")
    @ApiResponse(responseCode = "200", description = "Retrieved successfully")
    @GetMapping
    public ResponseEntity<List<${r"${controllerName}"}Response>> getAll() {
        // TODO: Implement get all logic
        return ResponseEntity.ok(List.of());
    }

    @Operation(summary = "Update ${r"${controllerName}"}")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Updated successfully"),
        @ApiResponse(responseCode = "404", description = "Not found")
    })
    @PutMapping("/{id}")
    public ResponseEntity<${r"${controllerName}"}Response> update(
            @PathVariable String id,
            @RequestBody @Valid Create${r"${controllerName}"}Request request) {
        // TODO: Implement update logic
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Patch ${r"${controllerName}"}")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Patched successfully"),
        @ApiResponse(responseCode = "404", description = "Not found")
    })
    @PatchMapping("/{id}")
    public ResponseEntity<${r"${controllerName}"}Response> patch(
            @PathVariable String id,
            @RequestBody Create${r"${controllerName}"}Request request) {
        // TODO: Implement patch logic
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Delete ${r"${controllerName}"}")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Not found")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        // TODO: Implement delete logic
        return ResponseEntity.noContent().build();
    }

    /**
     * Request record for creating a ${r"${controllerName}"}.
     */
    public record Create${r"${controllerName}"}Request(
    ) {}

    /**
     * Response record for ${r"${controllerName}"}.
     */
    public record ${r"${controllerName}"}Response(
    ) {}
}
