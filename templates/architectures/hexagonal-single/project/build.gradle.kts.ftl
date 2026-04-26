plugins {
    id("java")
<#if framework == "spring">
    alias(libs.plugins.spring.boot)
    alias(libs.plugins.spring.dependency.management)
<#elseif framework == "quarkus">
    id("io.quarkus") version "3.6.4"
</#if>
    id("co.com.pragma.archetype-generator") version "${pluginVersion}"
    alias(libs.plugins.pitest)
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

// Apply quality tools configuration
apply(from = "main.gradle")

dependencies {
<#if framework == "spring">
    // Spring Boot Actuator
    implementation(libs.spring.boot.starter.actuator)

    // MapStruct
    implementation(libs.mapstruct)
    annotationProcessor(libs.mapstruct.processor)

    // Lombok
    compileOnly(libs.lombok)
    annotationProcessor(libs.lombok)

    // SpringDoc OpenAPI
    <#if paradigm == "reactive">
    implementation(libs.springdoc.openapi.starter.webflux)
    <#else>
    implementation(libs.springdoc.openapi.starter.webmvc)
    </#if>

    // Testing
    testImplementation(libs.spring.boot.starter.test)
    <#if paradigm == "reactive">
    testImplementation(libs.reactor.test)
    </#if>

    // ArchUnit for architecture testing
    testImplementation(libs.archunit.junit5)
<#elseif framework == "quarkus">
    implementation(enforcedPlatform("io.quarkus.platform:quarkus-bom:3.6.4"))
    implementation("io.quarkus:quarkus-resteasy-reactive")
    implementation("io.quarkus:quarkus-arc")
    testImplementation("io.quarkus:quarkus-junit5")

    // ArchUnit for architecture testing
    testImplementation(libs.archunit.junit5)
</#if>
}

tasks.test {
    useJUnitPlatform()
}
