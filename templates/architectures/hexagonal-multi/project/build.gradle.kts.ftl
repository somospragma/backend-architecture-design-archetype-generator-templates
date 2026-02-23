plugins {
    id("java")
    id("org.springframework.boot") version "3.3.0" apply false
    id("io.spring.dependency-management") version "1.1.6" apply false
    id("com.pragma.archetype-generator") version "${pluginVersion}"
}

allprojects {
    group = "${groupId}"
    version = "${version}"
    
    repositories {
        mavenCentral()
    }
}

subprojects {
    apply(plugin = "java")
    
    java {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }
    
    dependencies {
        // Common dependencies for all modules
        compileOnly("org.projectlombok:lombok:1.18.36")
        annotationProcessor("org.projectlombok:lombok:1.18.36")
        
        testImplementation("org.junit.jupiter:junit-jupiter:5.10.1")
        testImplementation("org.mockito:mockito-core:5.7.0")
        testImplementation("org.mockito:mockito-junit-jupiter:5.7.0")
    }
    
    tasks.test {
        useJUnitPlatform()
    }
}
