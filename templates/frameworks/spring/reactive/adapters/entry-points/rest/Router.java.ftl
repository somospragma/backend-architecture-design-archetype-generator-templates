package ${packageName};

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RequestPredicates;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;

/**
 * Router configuration for ${controllerName} REST endpoints.
 * Defines routes using RouterFunction pattern instead of @RestController annotations,
 * following the functional endpoint model for Spring WebFlux.
 */
@Configuration
public class ${controllerName}Router {

    @Bean
    public RouterFunction<ServerResponse> ${controllerName?uncap_first}Routes(${controllerName}Handler handler) {
        return RouterFunctions.route()
            .path("/api/v1/${controllerName?lower_case}s", builder -> builder
                .GET("", handler::getAll)
                .GET("/{id}", handler::getById)
                .POST("", handler::create)
                .PUT("/{id}", handler::update)
                .DELETE("/{id}", handler::delete))
            .build();
    }
}
