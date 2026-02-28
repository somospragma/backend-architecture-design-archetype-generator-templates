plugins {
    id("java")
<#if framework == "spring">
    id("org.springframework.boot") version "3.2.1"
    id("io.spring.dependency-management") version "1.1.6"
<#elseif framework == "quarkus">
    id("io.quarkus") version "3.6.4"
</#if>
    id("co.com.pragma.archetype-generator") version "${pluginVersion}"
    id("info.solidsoft.pitest") version "1.15.0"
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
    // Spring Boot Actuator
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    
    // MapStruct
    implementation("org.mapstruct:mapstruct:1.5.5.Final")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.5.5.Final")
    
    // Lombok
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    <#if paradigm == "reactive">
    testImplementation("io.projectreactor:reactor-test")
    </#if>
    
    // ArchUnit for architecture testing
    testImplementation("com.tngtech.archunit:archunit-junit5:1.2.1")
<#elseif framework == "quarkus">
    implementation(enforcedPlatform("io.quarkus.platform:quarkus-bom:3.6.4"))
    implementation("io.quarkus:quarkus-resteasy-reactive")
    implementation("io.quarkus:quarkus-arc")
    testImplementation("io.quarkus:quarkus-junit5")
    
    // ArchUnit for architecture testing
    testImplementation("com.tngtech.archunit:archunit-junit5:1.2.1")
</#if>
}

tasks.test {
    useJUnitPlatform()
}

// Mutation Testing Configuration (PIT)
pitest {
    junit5PluginVersion.set("1.2.1")
    targetClasses.set(listOf("${basePackage}.*"))
    targetTests.set(listOf("${basePackage}.*"))
    excludedClasses.set(listOf(
        "${basePackage}.infrastructure.adapter.**",
        "${basePackage}.infrastructure.config.**",
        "${basePackage}.**.*Application",
        "${basePackage}.**.*Config",
        "${basePackage}.**.*Configuration"
    ))
    mutators.set(listOf("DEFAULTS"))
    outputFormats.set(listOf("HTML", "XML"))
    timestampedReports.set(false)
    mutationThreshold.set(50)
    coverageThreshold.set(50)
    threads.set(Runtime.getRuntime().availableProcessors())
    verbose.set(false)
}

// Validate Structure Task - Copies ArchUnit tests from templates and runs them
tasks.register("validateStructure") {
    group = "verification"
    description = "Validates the project architecture using ArchUnit tests (copies tests from templates first)"
    
    doFirst {
        println("Validating architecture structure...")
        println("Note: This task will be enhanced to copy tests from templates in a future version")
    }
    
    dependsOn("test")
    
    doLast {
        val testResults = file("build/test-results/test")
        if (testResults.exists()) {
            val archTests = testResults.listFiles()?.filter { 
                it.name.contains("Architecture") || it.name.contains("architecture")
            }
            if (archTests.isNullOrEmpty()) {
                throw GradleException("No architecture tests found!")
            }
            println("✓ Architecture validation completed successfully")
        }
    }
}
