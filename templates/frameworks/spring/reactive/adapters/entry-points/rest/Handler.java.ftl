package ${packageName};

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

/**
 * Handler for ${controllerName} REST endpoints.
 * Contains request handling methods that accept ServerRequest and return Mono<ServerResponse>.
 *
 * Note: This class uses @Component instead of @RestController,
 * following the functional endpoint model for Spring WebFlux.
 */
@Component
@RequiredArgsConstructor
public class ${controllerName}Handler {

    // TODO: Inject use case port
    // private final I${controllerName}UseCase ${controllerName?uncap_first}UseCase;

    public Mono<ServerResponse> getAll(ServerRequest request) {
        // TODO: Implement get all logic using use case
        return ServerResponse.ok()
            .contentType(MediaType.APPLICATION_JSON)
            .bodyValue("[]");
    }

    public Mono<ServerResponse> getById(ServerRequest request) {
        String id = request.pathVariable("id");
        // TODO: Implement get by id logic using use case
        return ServerResponse.ok()
            .contentType(MediaType.APPLICATION_JSON)
            .bodyValue("{}");
    }

    public Mono<ServerResponse> create(ServerRequest request) {
        // TODO: Implement create logic using use case
        return request.bodyToMono(Object.class)
            .flatMap(body -> ServerResponse.status(HttpStatus.CREATED)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(body));
    }

    public Mono<ServerResponse> update(ServerRequest request) {
        String id = request.pathVariable("id");
        // TODO: Implement update logic using use case
        return request.bodyToMono(Object.class)
            .flatMap(body -> ServerResponse.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(body));
    }

    public Mono<ServerResponse> delete(ServerRequest request) {
        String id = request.pathVariable("id");
        // TODO: Implement delete logic using use case
        return ServerResponse.noContent().build();
    }
}
