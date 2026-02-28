spring:
  application:
    name: ${projectName}

server:
  port: 8080

logging:
  level:
    root: INFO
    ${basePackage}: DEBUG

management:
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: when-authorized
