rootProject.name = "${projectName}"

pluginManagement {
    repositories {
        mavenLocal()
        gradlePluginPortal()
        mavenCentral()
    }
}

// Multi-module structure
include(
    "domain",
    "application",
    "infrastructure"
)
