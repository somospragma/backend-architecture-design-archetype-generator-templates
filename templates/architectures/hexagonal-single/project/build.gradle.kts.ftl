plugins {
    id("java")
<#if framework == "spring">
    id("org.springframework.boot") version "${springBootVersion}"
    id("io.spring.dependency-management") version "1.1.4"
</#if>
}

group = "${groupId}"
version = "${version}"

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(${javaVersion}))
    }
}

repositories {
    mavenCentral()
}

dependencies {
<#if framework == "spring">
    <#if paradigm == "reactive">
    // Spring WebFlux (Reactive)
    implementation("org.springframework.boot:spring-boot-starter-webflux")
    
    // R2DBC (Reactive Database)
    implementation("org.springframework.boot:spring-boot-starter-data-r2dbc")
    
    // Redis Reactive
    implementation("org.springframework.boot:spring-boot-starter-data-redis-reactive")
    <#else>
    // Spring MVC (Imperative)
    implementation("org.springframework.boot:spring-boot-starter-web")
    
    // JPA (Imperative Database)
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    
    // Redis
    implementation("org.springframework.boot:spring-boot-starter-data-redis")
    </#if>
    
    // Validation
    implementation("org.springframework.boot:spring-boot-starter-validation")
    
    // MapStruct
    implementation("org.mapstruct:mapstruct:${mapstructVersion}")
    annotationProcessor("org.mapstruct:mapstruct-processor:${mapstructVersion}")
    
    // Lombok (optional)
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    <#if paradigm == "reactive">
    testImplementation("io.projectreactor:reactor-test")
    </#if>
</#if>
}

tasks.test {
    useJUnitPlatform()
}
