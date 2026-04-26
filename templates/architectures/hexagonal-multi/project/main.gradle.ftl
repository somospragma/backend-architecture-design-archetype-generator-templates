// ============================================================
// Quality Tools Configuration (Multi-Module)
// ============================================================
// Plugins are applied in build.gradle.kts via version catalog.
// This file only configures them.

// ------------------------------------------------------------
// JaCoCo — Code Coverage (applied to all subprojects)
// ------------------------------------------------------------
subprojects {
    apply plugin: 'jacoco'

    jacoco {
        toolVersion = "0.8.12"
    }

    jacocoTestReport {
        dependsOn test
        reports {
            xml.required = true
            html.required = true
        }
    }

    jacocoTestCoverageVerification {
        violationRules {
            rule {
                limit {
                    counter = 'LINE'
                    minimum = 0.85
                }
            }
        }
    }

    test.finalizedBy jacocoTestReport

    // MapStruct — Annotation Processor Configuration
    tasks.withType(JavaCompile).configureEach {
        options.compilerArgs += [
            '-Amapstruct.defaultComponentModel=spring',
            '-Amapstruct.unmappedTargetPolicy=IGNORE'
        ]
    }
}

// ------------------------------------------------------------
// SonarQube — Static Analysis
// ------------------------------------------------------------
sonar {
    properties {
        property "sonar.projectKey", System.getenv("SONAR_PROJECT_KEY") ?: project.name
        property "sonar.projectName", System.getenv("SONAR_PROJECT_NAME") ?: project.name
        property "sonar.host.url", System.getenv("SONAR_HOST_URL") ?: "https://sonarcloud.io"
        property "sonar.token", System.getenv("SONAR_TOKEN") ?: findProperty("sonarToken") ?: ""
        property "sonar.organization", System.getenv("SONAR_ORGANIZATION") ?: ""
        property "sonar.java.coveragePlugin", "jacoco"
        property "sonar.coverage.jacoco.xmlReportPaths", "${r"${buildDir}"}/reports/jacoco/test/jacocoTestReport.xml"
        property "sonar.java.binaries", "${r"${buildDir}"}/classes"
    }
}

// ------------------------------------------------------------
// OWASP Dependency Check — Vulnerability Scanning
// ------------------------------------------------------------
dependencyCheck {
    failBuildOnCVSS = 7.0
    formats = ['HTML', 'JSON']
    suppressionFile = "owasp-suppressions.xml"
    analyzers {
        assemblyEnabled = false
    }
}
