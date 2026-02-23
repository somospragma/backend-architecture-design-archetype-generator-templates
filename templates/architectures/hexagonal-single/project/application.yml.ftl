server:
  port: 8080

spring:
  application:
    name: ${projectName}
<#if paradigm == "reactive">
  
  r2dbc:
    url: r2dbc:postgresql://localhost:5432/${projectName}
    username: postgres
    password: postgres
  
  data:
    redis:
      host: localhost
      port: 6379
<#else>
  
  datasource:
    url: jdbc:postgresql://localhost:5432/${projectName}
    username: postgres
    password: postgres
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
  
  data:
    redis:
      host: localhost
      port: 6379
</#if>

logging:
  level:
    root: INFO
    ${basePackage}: DEBUG
