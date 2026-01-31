package ${packageName}.infrastructure.entry-points.rest.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Response DTO for ${controllerName}.
 */
public record ${controllerName}Response(
    @JsonProperty("id")
    String id,

    @JsonProperty("name")
    String name,

    @JsonProperty("createdAt")
    String createdAt

    // TODO: Add more fields as needed
) {
}
