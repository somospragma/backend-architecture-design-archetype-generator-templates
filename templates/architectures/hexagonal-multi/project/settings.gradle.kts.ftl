rootProject.name = "${projectName}"

pluginManagement {
    repositories {
        mavenLocal()
        gradlePluginPortal()
    }
}

// Multi-module structure
include(
    "domain",
    "application",
    "infrastructure"
)
