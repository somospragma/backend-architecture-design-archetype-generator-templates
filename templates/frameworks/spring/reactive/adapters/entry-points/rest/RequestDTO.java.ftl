package ${packageName}.infrastructure.entry-points.rest.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * Request DTO for ${controllerName}.
 */
public record ${controllerName}Request(
    @JsonProperty("id")
    @NotBlank(message = "ID is required")
    String id,

    @JsonProperty("name")
    @NotBlank(message = "Name is required")
    String name

    // TODO: Add more fields as needed
) {
}
