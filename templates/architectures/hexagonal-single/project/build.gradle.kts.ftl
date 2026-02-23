plugins {
    id("java")
<#if framework == "spring">
    id("org.springframework.boot") version "3.2.1"
    id("io.spring.dependency-management") version "1.1.4"
<#elseif framework == "quarkus">
    id("io.quarkus") version "3.6.4"
</#if>
    id("com.pragma.archetype-generator") version "${pluginVersion}"
}

group = "${basePackage}"
version = "0.0.1-SNAPSHOT"

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
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
    // Spring Web (Imperative)
    implementation("org.springframework.boot:spring-boot-starter-web")
    
    // Spring Data JPA
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    
    // Redis
    implementation("org.springframework.boot:spring-boot-starter-data-redis")
    </#if>
    
    // Validation
    implementation("org.springframework.boot:spring-boot-starter-validation")
    
    // MapStruct
    implementation("org.mapstruct:mapstruct:1.5.5.Final")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.5.5.Final")
    
    // Lombok (optional)
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    <#if paradigm == "reactive">
    testImplementation("io.projectreactor:reactor-test")
    </#if>
<#elseif framework == "quarkus">
    implementation(enforcedPlatform("io.quarkus.platform:quarkus-bom:3.6.4"))
    implementation("io.quarkus:quarkus-resteasy-reactive")
    implementation("io.quarkus:quarkus-arc")
    testImplementation("io.quarkus:quarkus-junit5")
</#if>
}

tasks.test {
    useJUnitPlatform()
}
