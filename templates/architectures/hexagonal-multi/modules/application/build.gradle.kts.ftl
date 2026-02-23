plugins {
    id("java-library")
}

description = "Application layer - Use case orchestration"

dependencies {
    // Depends on domain
    api(project(":domain"))
    
    // Reactive support
    implementation("io.projectreactor:reactor-core:3.6.1")
    
    // Testing
    testImplementation("io.projectreactor:reactor-test:3.6.1")
}
