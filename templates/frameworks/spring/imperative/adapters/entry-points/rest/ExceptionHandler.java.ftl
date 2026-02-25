package ${packageName};

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.context.request.WebRequest;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Global exception handler for REST controllers.
 * Maps domain exceptions to appropriate HTTP status codes.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

  private static final String TIMESTAMP_KEY = "timestamp";
  private static final String STATUS_KEY = "status";
  private static final String ERROR_KEY = "error";
  private static final String MESSAGE_KEY = "message";
  private static final String PATH_KEY = "path";

  @ExceptionHandler(IllegalArgumentException.class)
  public ResponseEntity<Map<String, Object>> handleIllegalArgumentException(
      IllegalArgumentException ex,
      WebRequest request) {
    return buildErrorResponse(
        HttpStatus.BAD_REQUEST,
        ex.getMessage(),
        request);
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<Map<String, Object>> handleValidationException(
      MethodArgumentNotValidException ex,
      WebRequest request) {
    Map<String, String> errors = new HashMap<>();
    ex.getBindingResult().getFieldErrors().forEach(error ->
        errors.put(error.getField(), error.getDefaultMessage())
    );
    
    Map<String, Object> body = new HashMap<>();
    body.put(TIMESTAMP_KEY, LocalDateTime.now());
    body.put(STATUS_KEY, HttpStatus.BAD_REQUEST.value());
    body.put(ERROR_KEY, "Validation Failed");
    body.put("errors", errors);
    body.put(PATH_KEY, request.getDescription(false).replace("uri=", ""));
    
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
  }

  @ExceptionHandler(RuntimeException.class)
  public ResponseEntity<Map<String, Object>> handleRuntimeException(
      RuntimeException ex,
      WebRequest request) {
    return buildErrorResponse(
        HttpStatus.INTERNAL_SERVER_ERROR,
        "Internal server error: " + ex.getMessage(),
        request);
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<Map<String, Object>> handleGenericException(
      Exception ex,
      WebRequest request) {
    return buildErrorResponse(
        HttpStatus.INTERNAL_SERVER_ERROR,
        "An unexpected error occurred",
        request);
  }

  private ResponseEntity<Map<String, Object>> buildErrorResponse(
      HttpStatus status,
      String message,
      WebRequest request) {
    Map<String, Object> body = new HashMap<>();
    body.put(TIMESTAMP_KEY, LocalDateTime.now());
    body.put(STATUS_KEY, status.value());
    body.put(ERROR_KEY, status.getReasonPhrase());
    body.put(MESSAGE_KEY, message);
    body.put(PATH_KEY, request.getDescription(false).replace("uri=", ""));
    
    return ResponseEntity.status(status).body(body);
  }
}
