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
<#if paradigm == "reactive">
    implementation("org.springframework.boot:spring-boot-starter-webflux")
<#else>
    implementation("org.springframework.boot:spring-boot-starter-web")
</#if>
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    
    // MapStruct for mapping
    implementation("org.mapstruct:mapstruct:${versions.libraries["mapstruct"]}")
    annotationProcessor("org.mapstruct:mapstruct-processor:${versions.libraries["mapstruct"]}")
    
    // Validation
    implementation("org.springframework.boot:spring-boot-starter-validation")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
<#if paradigm == "reactive">
    testImplementation("io.projectreactor:reactor-test")
</#if>
}

// Configure bootJar task
tasks.named<org.springframework.boot.gradle.tasks.bundling.BootJar>("bootJar") {
    enabled = true
    mainClass.set("${basePackage}.${projectNamePascalCase}Application")
}

// Disable plain jar
tasks.named<Jar>("jar") {
    enabled = false
}
