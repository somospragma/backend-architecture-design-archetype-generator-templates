server:
  port: 8080
  # WARNING: Do not store credentials or sensitive data in source control
  # Use environment variables or secret management in production
  
spring:
  # Reactive web server configuration
  reactor:
    context-propagation: auto

management:
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: when-authorized
    
logging:
  level:
    ${packageName}: DEBUG
    org.springframework.web: INFO
    reactor.netty: INFO
