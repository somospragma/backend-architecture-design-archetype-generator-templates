plugins {
    id("java")
    jacoco
    alias(libs.plugins.spring.boot) apply false
    alias(libs.plugins.spring.dependency.management) apply false
    id("co.com.pragma.archetype-generator") version "${pluginVersion}"
    alias(libs.plugins.pitest) apply false
    alias(libs.plugins.sonarqube)
    alias(libs.plugins.owasp.dependencycheck)
}

allprojects {
    group = "${basePackage}"
    version = "0.0.1-SNAPSHOT"

    repositories {
        mavenCentral()
    }
}

subprojects {
    apply(plugin = "java")

    java {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(21))
        }
    }

    val catalog = rootProject.the<VersionCatalogsExtension>().named("libs")

    dependencies {
        // Lombok
        compileOnly(catalog.findLibrary("lombok").get())
        annotationProcessor(catalog.findLibrary("lombok").get())

        // Testing
        testImplementation(catalog.findLibrary("spring-boot-starter-test").get())
        testImplementation(catalog.findLibrary("archunit-junit5").get())
    }

    tasks.test {
        useJUnitPlatform()
    }
}

// Domain module — no Spring dependencies
configure(subprojects.filter { it.name == "domain" }) {
    val catalog = rootProject.the<VersionCatalogsExtension>().named("libs")
    dependencies {
        implementation(catalog.findLibrary("mapstruct").get())
        annotationProcessor(catalog.findLibrary("mapstruct-processor").get())
<#if paradigm == "reactive">
        // Reactor core for reactive ports (Mono, Flux)
        implementation(catalog.findLibrary("reactor-core").get())
</#if>
    }
}

// Infrastructure module — Spring Boot + adapters
configure(subprojects.filter { it.name == "infrastructure" }) {
    apply(plugin = "org.springframework.boot")
    apply(plugin = "io.spring.dependency-management")
    apply(plugin = "info.solidsoft.pitest")

    val catalog = rootProject.the<VersionCatalogsExtension>().named("libs")
    dependencies {
        implementation(project(":domain"))
        implementation(project(":application"))

        // Spring Boot Actuator
        implementation(catalog.findLibrary("spring-boot-starter-actuator").get())

        // MapStruct
        implementation(catalog.findLibrary("mapstruct").get())
        annotationProcessor(catalog.findLibrary("mapstruct-processor").get())

        // SpringDoc OpenAPI
<#if paradigm == "reactive">
        implementation(catalog.findLibrary("springdoc-openapi-starter-webflux").get())
<#else>
        implementation(catalog.findLibrary("springdoc-openapi-starter-webmvc").get())
</#if>

<#if paradigm == "reactive">
        testImplementation(catalog.findLibrary("reactor-test").get())
</#if>
    }
}

// Application module
configure(subprojects.filter { it.name == "application" }) {
    dependencies {
        implementation(project(":domain"))
    }
}

// Apply quality tools configuration
apply(from = "main.gradle")
