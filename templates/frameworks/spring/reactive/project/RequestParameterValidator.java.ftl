package ${configPackage};

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validator;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

import java.util.Set;
import java.util.stream.Collectors;

/**
 * Abstract base class for non-blocking request parameter validation in WebFlux.
 * Provides methods to validate request objects reactively using Jakarta Validation.
 *
 * Subclasses can extend this to add domain-specific validation logic.
 *
 * Usage example:
 * <pre>
 *   public class MyValidator extends RequestParameterValidator {
 *       public Mono<MyRequest> validate(MyRequest request) {
 *           return validateRequest(request);
 *       }
 *   }
 * </pre>
 */
@RequiredArgsConstructor
public abstract class RequestParameterValidator {

    private final Validator validator;

    /**
     * Validates the given request object using Jakarta Bean Validation.
     * Returns a Mono that emits the request if valid, or errors with
     * an IllegalArgumentException containing all violation messages.
     *
     * @param request the request object to validate
     * @param <T> the type of the request
     * @return Mono emitting the validated request or an error
     */
    protected <T> Mono<T> validateRequest(T request) {
        return Mono.fromCallable(() -> {
            Set<ConstraintViolation<T>> violations = validator.validate(request);
            if (!violations.isEmpty()) {
                String errorMessages = violations.stream()
                    .map(violation -> violation.getPropertyPath() + ": " + violation.getMessage())
                    .collect(Collectors.joining(", "));
                throw new IllegalArgumentException("Validation failed: " + errorMessages);
            }
            return request;
        });
    }

    /**
     * Validates the given request object against a specific validation group.
     *
     * @param request the request object to validate
     * @param groups the validation groups to apply
     * @param <T> the type of the request
     * @return Mono emitting the validated request or an error
     */
    protected <T> Mono<T> validateRequest(T request, Class<?>... groups) {
        return Mono.fromCallable(() -> {
            Set<ConstraintViolation<T>> violations = validator.validate(request, groups);
            if (!violations.isEmpty()) {
                String errorMessages = violations.stream()
                    .map(violation -> violation.getPropertyPath() + ": " + violation.getMessage())
                    .collect(Collectors.joining(", "));
                throw new IllegalArgumentException("Validation failed: " + errorMessages);
            }
            return request;
        });
    }
}
