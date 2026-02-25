spring:
  application:
    name: ${projectName}
  
  # Spring MVC Configuration
  mvc:
    servlet:
      path: /api

server:
  port: 8080
  # Tomcat Configuration
  tomcat:
    threads:
      max: 200
      min-spare: 10
    connection-timeout: 20000

# Logging
logging:
  level:
    root: INFO
    ${basePackage}: DEBUG
    org.springframework.web: DEBUG

# Actuator (optional)
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: when-authorized
