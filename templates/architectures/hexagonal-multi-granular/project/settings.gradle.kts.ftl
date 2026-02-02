rootProject.name = "${projectName}"

pluginManagement {
    repositories {
        mavenLocal()
        gradlePluginPortal()
    }
}

// Domain modules (inside domain/ folder)
include("domain:model")
include("domain:ports")
include("domain:usecase")

// Main application (inside application/ folder)
include("application:app-service")
