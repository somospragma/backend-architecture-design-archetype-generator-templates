[versions]
spring-boot = "4.0.3"
spring-dependency-management = "1.1.7"
java = "21"
mapstruct = "1.6.3"
lombok = "1.18.36"
archunit = "1.3.0"
springdoc-openapi = "2.8.6"
pitest = "1.15.0"
pitest-junit5 = "1.2.1"

[libraries]
mapstruct = { module = "org.mapstruct:mapstruct", version.ref = "mapstruct" }
mapstruct-processor = { module = "org.mapstruct:mapstruct-processor", version.ref = "mapstruct" }
lombok = { module = "org.projectlombok:lombok", version.ref = "lombok" }
archunit-junit5 = { module = "com.tngtech.archunit:archunit-junit5", version.ref = "archunit" }
springdoc-openapi-starter-webmvc = { module = "org.springdoc:springdoc-openapi-starter-webmvc-ui", version.ref = "springdoc-openapi" }
springdoc-openapi-starter-webflux = { module = "org.springdoc:springdoc-openapi-starter-webflux-ui", version.ref = "springdoc-openapi" }
spring-boot-starter-actuator = { module = "org.springframework.boot:spring-boot-starter-actuator" }
spring-boot-starter-test = { module = "org.springframework.boot:spring-boot-starter-test" }
reactor-test = { module = "io.projectreactor:reactor-test" }

[plugins]
spring-boot = { id = "org.springframework.boot", version.ref = "spring-boot" }
spring-dependency-management = { id = "io.spring.dependency-management", version.ref = "spring-dependency-management" }
pitest = { id = "info.solidsoft.pitest", version.ref = "pitest" }
