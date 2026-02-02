plugins {
    id("java-library")
}

description = "Driven adapter - ${adapterType}"

dependencies {
    // Domain dependencies
    implementation(project(":domain:model"))
    implementation(project(":domain:ports"))

    // Spring Boot dependencies
    implementation("org.springframework.boot:spring-boot-starter-webflux")
    
<#if adapterType == "redis">
    // Redis dependencies
    implementation("org.springframework.boot:spring-boot-starter-data-redis-reactive")
<#elseif adapterType == "mongodb">
    // MongoDB dependencies
    implementation("org.springframework.boot:spring-boot-starter-data-mongodb-reactive")
<#elseif adapterType == "postgresql">
    // PostgreSQL dependencies
    implementation("org.springframework.boot:spring-boot-starter-data-r2dbc")
    runtimeOnly("org.postgresql:r2dbc-postgresql")
<#elseif adapterType == "kafka">
    // Kafka dependencies
    implementation("org.springframework.kafka:spring-kafka")
<#elseif adapterType == "rest_client">
    // WebClient for REST calls
    implementation("org.springframework.boot:spring-boot-starter-webflux")
</#if>

    // Lombok
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
}
