plugins {
    id("java")
    id("org.springframework.boot")
    id("io.spring.dependency-management")
}

description = "Infrastructure layer - Adapters and technical details"

dependencies {
    // Depends on domain and application
    implementation(project(":domain"))
    implementation(project(":application"))
    
    // Spring Boot
    implementation("org.springframework.boot:spring-boot-starter-webflux")
    implementation("org.springframework.boot:spring-boot-starter-data-redis-reactive")
    
    // MapStruct for mapping
    implementation("org.mapstruct:mapstruct:1.5.5.Final")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.5.5.Final")
    
    // Validation
    implementation("org.springframework.boot:spring-boot-starter-validation")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("io.projectreactor:reactor-test")
}

// Configure bootJar task
tasks.named<org.springframework.boot.gradle.tasks.bundling.BootJar>("bootJar") {
    enabled = true
    mainClass.set("${basePackage}.infrastructure.config.${projectNamePascalCase}Application")
}

// Disable plain jar
tasks.named<Jar>("jar") {
    enabled = false
}
