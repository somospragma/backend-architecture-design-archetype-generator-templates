plugins {
    id("java")
    id("io.spring.dependency-management")
}

description = "${direction?cap_first} adapter - ${adapterType}"

// Versions of Spring Boot managed dependencies come from the Boot BOM
dependencyManagement {
    imports {
        mavenBom(org.springframework.boot.gradle.plugin.SpringBootPlugin.BOM_COORDINATES)
    }
}

dependencies {
    implementation(project(":model"))
    implementation(project(":ports"))

    // Baseline every adapter compiles against
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.springframework.boot:spring-boot-starter-validation")
<#if paradigm == "reactive">
    implementation("io.projectreactor:reactor-core")
</#if>
    implementation(libs.mapstruct)
    annotationProcessor(libs.mapstruct.processor)

    // Adapter-specific dependencies are added when the adapter is generated
}
