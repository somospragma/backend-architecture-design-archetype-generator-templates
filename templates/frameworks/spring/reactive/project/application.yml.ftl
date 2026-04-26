spring:
  application:
    name: ${projectName}
    title: ${projectNamePascalCase}
  lifecycle:
    timeout-per-shutdown-phase: 30s

server:
  port: 8080
  shutdown: graceful

# Database configuration (example — uncomment and adjust per adapter)
# spring.r2dbc:
#   url: ${r"${DB_URL}"}
#   username: ${r"${DB_USERNAME}"}
#   password: ${r"${DB_PASSWORD}"}

# Logging — structured JSON output for production
logging:
  level:
    root: INFO
    ${basePackage}: DEBUG
    org.springframework.web: DEBUG
    reactor.netty: INFO
  structured:
    format:
      console: logfmt
  pattern:
    correlation: "[${r"${spring.application.name:}"},${r"${traceId:-}"},${r"${spanId:-}"}] "

# Actuator & Health Probes
management:
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: health,info,prometheus
  endpoint:
    health:
      show-details: when-authorized
      probes:
        enabled: true
