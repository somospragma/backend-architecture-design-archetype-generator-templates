package ${configPackage};

import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Global exception handler for imperative REST endpoints.
 * Returns RFC 7807 ProblemDetail responses for all handled exceptions.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleMethodArgumentNotValid(MethodArgumentNotValidException ex) {
        ProblemDetail problemDetail = ProblemDetail.forStatusAndDetail(
            HttpStatus.BAD_REQUEST,
            ErrorType.VALIDATION_ERROR.getDetail()
        );
        problemDetail.setTitle(ErrorType.VALIDATION_ERROR.getTitle());
        problemDetail.setType(URI.create("about:blank"));

        List<Map<String, String>> fieldErrors = ex.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(error -> Map.of(
                "field", error.getField(),
                "message", error.getDefaultMessage() != null ? error.getDefaultMessage() : "Invalid value"
            ))
            .collect(Collectors.toList());

        problemDetail.setProperty("errors", fieldErrors);
        return problemDetail;
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ProblemDetail handleConstraintViolation(ConstraintViolationException ex) {
        ProblemDetail problemDetail = ProblemDetail.forStatusAndDetail(
            HttpStatus.BAD_REQUEST,
            ErrorType.VALIDATION_ERROR.getDetail()
        );
        problemDetail.setTitle(ErrorType.VALIDATION_ERROR.getTitle());
        problemDetail.setType(URI.create("about:blank"));

        List<Map<String, String>> violations = ex.getConstraintViolations()
            .stream()
            .map(violation -> Map.of(
                "field", extractFieldName(violation),
                "message", violation.getMessage()
            ))
            .collect(Collectors.toList());

        problemDetail.setProperty("errors", violations);
        return problemDetail;
    }

    @ExceptionHandler(Exception.class)
    public ProblemDetail handleGenericException(Exception ex) {
        ProblemDetail problemDetail = ProblemDetail.forStatusAndDetail(
            HttpStatus.INTERNAL_SERVER_ERROR,
            ErrorType.INTERNAL_ERROR.getDetail()
        );
        problemDetail.setTitle(ErrorType.INTERNAL_ERROR.getTitle());
        problemDetail.setType(URI.create("about:blank"));
        return problemDetail;
    }

    private String extractFieldName(ConstraintViolation<?> violation) {
        String propertyPath = violation.getPropertyPath().toString();
        int lastDot = propertyPath.lastIndexOf('.');
        return lastDot >= 0 ? propertyPath.substring(lastDot + 1) : propertyPath;
    }
}
