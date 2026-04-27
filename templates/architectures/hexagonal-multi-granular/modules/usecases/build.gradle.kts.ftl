plugins {
    id("java-library")
}

description = "Domain use cases - Business logic implementation"

dependencies {
    api(project(":model"))
    api(project(":ports"))
}
