// ============================================================
// Quality Tools Configuration
// ============================================================
// Plugins are applied in build.gradle.kts via version catalog.
// This file only configures them.

// ------------------------------------------------------------
// JaCoCo — Code Coverage
// ------------------------------------------------------------
jacoco {
    toolVersion = "${versions.libraries["jacoco"]}"
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
                minimum = ${versions.quality["jacoco-min-coverage"]}
            }
        }
    }
}

test.finalizedBy jacocoTestReport
// Note: jacocoTestCoverageVerification is NOT finalized by jacocoTestReport
// Run it explicitly: ./gradlew jacocoTestCoverageVerification
// This prevents build failures on newly generated projects with no business code.

// ------------------------------------------------------------
// PIT — Mutation Testing
// ------------------------------------------------------------
pitest {
    junit5PluginVersion = '${versions.libraries["pitest-junit5"]}'
    targetClasses = ["${basePackage}.*"]
    targetTests = ["${basePackage}.*"]
    excludedClasses = [
        "${basePackage}.infrastructure.adapter.**",
        "${basePackage}.infrastructure.config.**",
        "${basePackage}.**.*Application",
        "${basePackage}.**.*Config",
        "${basePackage}.**.*Configuration"
    ]
    mutators = ['DEFAULTS']
    outputFormats = ['HTML', 'XML']
    timestampedReports = false
    mutationThreshold = ${versions.quality["pit-mutation-threshold"]}
    coverageThreshold = 20
    threads = Runtime.runtime.availableProcessors()
    verbose = false
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
    failBuildOnCVSS = ${versions.quality["owasp-fail-on-cvss"]}
    formats = ['HTML', 'JSON']
    suppressionFile = "owasp-suppressions.xml"
    analyzers {
        assemblyEnabled = false
    }
}

// ------------------------------------------------------------
// MapStruct — Annotation Processor Configuration
// ------------------------------------------------------------
tasks.withType(JavaCompile).configureEach {
    options.compilerArgs += [
        '-Amapstruct.defaultComponentModel=spring',
        '-Amapstruct.unmappedTargetPolicy=IGNORE'
    ]
}
