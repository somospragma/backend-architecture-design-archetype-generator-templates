${adapterName?lower_case}:
  http:
    base-url: http://localhost:8080
    timeout: 5000

logging:
  level:
    org.springframework.web.client.RestTemplate: DEBUG
    org.apache.http: DEBUG
