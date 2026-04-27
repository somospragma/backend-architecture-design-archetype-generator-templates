package ${packageName};

<#if useCaseName?? && useCaseName?has_content>
import ${portsPackage}.I${useCaseName}UseCase;
</#if>
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
 * REST Controller for ${controllerName}.
 * Handles HTTP requests and delegates to use cases.
 */
@Tag(name = "${controllerName}", description = "${controllerName} API")
@RestController
@RequestMapping("/api/v1/${controllerName?lower_case}s")
@Validated
@RequiredArgsConstructor
public class ${controllerName}Controller {

<#if useCaseName?? && useCaseName?has_content>
    private final I${useCaseName}UseCase ${useCaseName?uncap_first}UseCase;
</#if>

    @Operation(summary = "Create ${controllerName}")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request")
    })
    @PostMapping
    public ResponseEntity<${controllerName}Response> create(
            @RequestBody @Valid Create${controllerName}Request request) {
        // TODO: Implement create logic
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @Operation(summary = "Get ${controllerName} by ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Found successfully"),
        @ApiResponse(responseCode = "404", description = "Not found")
    })
    @GetMapping("/{id}")
    public ResponseEntity<${controllerName}Response> getById(@PathVariable String id) {
        // TODO: Implement get by id logic
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Get all ${controllerName}s")
    @ApiResponse(responseCode = "200", description = "Retrieved successfully")
    @GetMapping
    public ResponseEntity<List<${controllerName}Response>> getAll() {
        // TODO: Implement get all logic
        return ResponseEntity.ok(List.of());
    }

    @Operation(summary = "Update ${controllerName}")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Updated successfully"),
        @ApiResponse(responseCode = "404", description = "Not found")
    })
    @PutMapping("/{id}")
    public ResponseEntity<${controllerName}Response> update(
            @PathVariable String id,
            @RequestBody @Valid Create${controllerName}Request request) {
        // TODO: Implement update logic
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Patch ${controllerName}")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Patched successfully"),
        @ApiResponse(responseCode = "404", description = "Not found")
    })
    @PatchMapping("/{id}")
    public ResponseEntity<${controllerName}Response> patch(
            @PathVariable String id,
            @RequestBody Create${controllerName}Request request) {
        // TODO: Implement patch logic
        return ResponseEntity.ok().build();
    }

    @Operation(summary = "Delete ${controllerName}")
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
     * Request record for creating a ${controllerName}.
     */
    public record Create${controllerName}Request(
    ) {}

    /**
     * Response record for ${controllerName}.
     */
    public record ${controllerName}Response(
    ) {}
}
