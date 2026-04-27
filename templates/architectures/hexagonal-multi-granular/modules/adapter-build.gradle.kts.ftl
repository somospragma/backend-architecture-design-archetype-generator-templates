plugins {
    id("java")
    id("org.springframework.boot") apply false
    id("io.spring.dependency-management")
}

dependencies {
    implementation(project(":model"))
    implementation(project(":ports"))

    // Adapter-specific dependencies will be added dynamically
}
