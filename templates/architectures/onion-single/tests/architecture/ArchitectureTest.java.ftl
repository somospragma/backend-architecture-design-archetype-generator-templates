package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.library.Architectures.onionArchitecture;

/**
 * Onion architecture rules. Rings, from the core outwards:
 *
 *   domain.model          entities and value objects, depends on nothing
 *   domain.gateway        interfaces for what the domain needs from outside
 *   application.usecase   use cases, orchestrate the domain
 *   infrastructure        entry points (call use cases) and driven adapters
 *                         (implement domain gateways)
 *
 * Dependencies only point inwards. Rules shared with other architectures
 * (framework-free core, adapters, naming, immutability) live in
 * DomainPurityTest, AdapterRulesTest, NamingConventionTest, ImmutabilityTest
 * and CodingRulesTest.
 *
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class ArchitectureTest {

    private static JavaClasses classes;

    @BeforeAll
    static void setup() {
        classes = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages("${basePackage}");
    }

    @Test
    void dependenciesPointInwards() {
        onionArchitecture()
            .domainModels("..domain.model..")
            .domainServices("..domain.gateway..")
            .applicationServices("..application..")
            .adapter("entrypoints", "..infrastructure.entrypoints..")
            .adapter("drivenadapters", "..infrastructure.drivenadapters..")
            .withOptionalLayers(true)
            .because("In onion architecture every ring may only depend on the rings inside it, "
                + "and adapters must not know each other")
            .check(classes);
    }
}
