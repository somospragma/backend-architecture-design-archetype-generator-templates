server:
  port: 8080
  # WARNING: Do not store credentials or sensitive data in source control
  # Use environment variables or secret management in production
  
spring:
  mvc:
    servlet:
      path: ${basePath!"/api"}
  
  # Spring MVC configuration
  web:
    resources:
      add-mappings: true
    
logging:
  level:
    ${packageName}: DEBUG
    org.springframework.web: INFO
    org.springframework.web.servlet: INFO
