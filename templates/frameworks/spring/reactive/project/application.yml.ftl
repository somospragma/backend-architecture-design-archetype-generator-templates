spring:
  application:
    name: ${projectName}
    title: ${projectNamePascalCase}

server:
  port: 8080

# Logging
logging:
  level:
    root: INFO
    ${basePackage}: DEBUG
    org.springframework.web: DEBUG
    reactor.netty: INFO

# Actuator (optional)
management:
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: when-authorized
