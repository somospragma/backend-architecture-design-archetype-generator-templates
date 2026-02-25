${adapterName?lower_case}:
  http:
    base-url: http://localhost:8080
    timeout: 5000

logging:
  level:
    org.springframework.web.reactive.function.client: DEBUG
    reactor.netty.http.client: DEBUG
