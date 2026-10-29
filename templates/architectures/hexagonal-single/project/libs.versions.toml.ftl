[versions]
# Rendered from versions.yml in the template repository
spring-boot = "${versions.libraries["spring-boot"]}"
spring-dependency-management = "${versions.libraries["spring-dependency-management"]}"
java = "${versions.java}"
mapstruct = "${versions.libraries["mapstruct"]}"
lombok = "${versions.libraries["lombok"]}"
archunit = "${versions.libraries["archunit"]}"
springdoc-openapi = "${versions.libraries["springdoc-openapi"]}"
pitest = "${versions.libraries["pitest"]}"
pitest-junit5 = "${versions.libraries["pitest-junit5"]}"
sonarqube = "${versions.libraries["sonarqube"]}"
owasp-dependencycheck = "${versions.libraries["owasp-dependencycheck"]}"
reactor = "${versions.libraries["reactor"]}"

[libraries]
mapstruct = { module = "org.mapstruct:mapstruct", version.ref = "mapstruct" }
mapstruct-processor = { module = "org.mapstruct:mapstruct-processor", version.ref = "mapstruct" }
lombok = { module = "org.projectlombok:lombok", version.ref = "lombok" }
archunit-junit5 = { module = "com.tngtech.archunit:archunit-junit5", version.ref = "archunit" }
springdoc-openapi-starter-webmvc = { module = "org.springdoc:springdoc-openapi-starter-webmvc-ui", version.ref = "springdoc-openapi" }
springdoc-openapi-starter-webflux = { module = "org.springdoc:springdoc-openapi-starter-webflux-ui", version.ref = "springdoc-openapi" }
spring-boot-starter-actuator = { module = "org.springframework.boot:spring-boot-starter-actuator" }
spring-boot-starter-test = { module = "org.springframework.boot:spring-boot-starter-test" }
reactor-core = { module = "io.projectreactor:reactor-core", version.ref = "reactor" }
reactor-test = { module = "io.projectreactor:reactor-test" }

[plugins]
spring-boot = { id = "org.springframework.boot", version.ref = "spring-boot" }
spring-dependency-management = { id = "io.spring.dependency-management", version.ref = "spring-dependency-management" }
pitest = { id = "info.solidsoft.pitest", version.ref = "pitest" }
sonarqube = { id = "org.sonarqube", version.ref = "sonarqube" }
owasp-dependencycheck = { id = "org.owasp.dependencycheck", version.ref = "owasp-dependencycheck" }
