spring:
  data:
    mongodb:
      uri: mongodb://localhost:27017
      database: ${projectName?lower_case}
      repositories:
        enabled: true

logging:
  level:
    org.springframework.data.mongodb: DEBUG
    org.mongodb.driver: INFO
