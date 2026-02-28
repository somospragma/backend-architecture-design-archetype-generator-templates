plugins {
    id("java")
    id("org.springframework.boot") version "3.3.0" apply false
    id("io.spring.dependency-management") version "1.1.6" apply false
    id("co.com.pragma.archetype-generator") version "${pluginVersion}"
    id("info.solidsoft.pitest") version "1.15.0" apply false
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
        
        // ArchUnit for architecture testing
        testImplementation("com.tngtech.archunit:archunit-junit5:1.2.1")
    }
    
    tasks.test {
        useJUnitPlatform()
    }
}

// Mutation Testing Configuration (PIT) - Applied to infrastructure module
configure(subprojects.filter { it.name == "infrastructure" }) {
    apply(plugin = "info.solidsoft.pitest")
    
    configure<info.solidsoft.gradle.pitest.PitestPluginExtension> {
        junit5PluginVersion.set("1.2.1")
        targetClasses.set(listOf("${r"${basePackage}"}.*"))
        targetTests.set(listOf("${r"${basePackage}"}.*"))
        excludedClasses.set(listOf(
            "${r"${basePackage}"}.infrastructure.adapter.**",
            "${r"${basePackage}"}.infrastructure.config.**",
            "${r"${basePackage}"}.**.*Application",
            "${r"${basePackage}"}.**.*Config",
            "${r"${basePackage}"}.**.*Configuration"
        ))
        mutators.set(listOf("DEFAULTS"))
        outputFormats.set(listOf("HTML", "XML"))
        timestampedReports.set(false)
        mutationThreshold.set(50)
        coverageThreshold.set(50)
        threads.set(Runtime.getRuntime().availableProcessors())
        verbose.set(false)
    }
}
