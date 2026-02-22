server:
  port: 8080
  # WARNING: Do not store credentials or sensitive data in source control
  # Use environment variables or secret management in production
  
spring:
  webflux:
    base-path: ${basePath!"/api"}
  
  # Reactive web server configuration
  reactor:
    context-propagation: auto
    
logging:
  level:
    ${packageName}: DEBUG
    org.springframework.web: INFO
    reactor.netty: INFO
