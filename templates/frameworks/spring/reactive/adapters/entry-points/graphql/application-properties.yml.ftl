spring:
  graphql:
    graphiql:
      enabled: true
      path: /graphiql
    path: /graphql
    schema:
      printer:
        enabled: true
    websocket:
      path: /graphql
    cors:
      allowed-origins: "*"
      allowed-methods: "*"

logging:
  level:
    org.springframework.graphql: DEBUG
    graphql: DEBUG
