plugins {
    id("java")
    id("org.springframework.boot")
    id("io.spring.dependency-management")
}

description = "Main application - Wires everything together"

dependencies {
    // Depends on domain modules
    implementation(project(":model"))
    implementation(project(":ports"))
    implementation(project(":usecases"))

    // Spring Boot Actuator
    implementation("org.springframework.boot:spring-boot-starter-actuator")

    // MapStruct for mapping
    implementation("org.mapstruct:mapstruct:${versions.libraries["mapstruct"]}")
    annotationProcessor("org.mapstruct:mapstruct-processor:${versions.libraries["mapstruct"]}")

    // Validation
    implementation("org.springframework.boot:spring-boot-starter-validation")

    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

// Configure bootJar task
tasks.named<org.springframework.boot.gradle.tasks.bundling.BootJar>("bootJar") {
    enabled = true
    mainClass.set("${basePackage}.config.${projectNamePascalCase}Application")
}

// Disable plain jar
tasks.named<Jar>("jar") {
    enabled = false
}
