rootProject.name = "${projectName}"

pluginManagement {
    repositories {
        mavenLocal()
        gradlePluginPortal()
        mavenCentral()
    }
}

// Domain modules
include("model")
project(":model").projectDir = file("domain/model")

include("ports")
project(":ports").projectDir = file("domain/ports")

include("usecases")
project(":usecases").projectDir = file("domain/usecases")

// Infrastructure helpers
include("helpers")
project(":helpers").projectDir = file("infrastructure/helpers")

// Main application
include("app-service")
project(":app-service").projectDir = file("application/app-service")
