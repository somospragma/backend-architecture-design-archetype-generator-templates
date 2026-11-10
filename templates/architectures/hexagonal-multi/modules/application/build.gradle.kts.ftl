plugins {
    id("java-library")
}

description = "Application layer - Use case orchestration"

dependencies {
    // Depends on domain
    api(project(":domain"))
    
    // Reactive support
    implementation("io.projectreactor:reactor-core:${versions.libraries["reactor"]}")
    
    // Testing
    testImplementation("io.projectreactor:reactor-test:${versions.libraries["reactor"]}")
}
