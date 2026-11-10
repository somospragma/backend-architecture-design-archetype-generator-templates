plugins {
    id("java-library")
}

description = "Shared cross-cutting utilities"

dependencies {
    api(project(":model"))
    api(project(":ports"))
}
