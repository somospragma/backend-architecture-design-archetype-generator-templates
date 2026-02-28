server:
  port: 8080
  # WARNING: Do not store credentials or sensitive data in source control
  # Use environment variables or secret management in production
  
spring:
  # Spring MVC configuration
  web:
    resources:
      add-mappings: true

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
    org.springframework.web.servlet: INFO
