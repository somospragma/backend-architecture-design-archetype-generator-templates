package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.lang.ArchRule;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;
import static com.tngtech.archunit.library.Architectures.onionArchitecture;

/**
 * Architecture tests to validate clean architecture principles.
 * These tests ensure that the project follows the onion architecture pattern.
 * 
 * DO NOT MODIFY OR DELETE THIS FILE.
 * This file is automatically synchronized during build to ensure architecture rules are enforced.
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
    void domainLayerShouldNotDependOnApplicationLayer() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat().resideInAPackage("..application..")
            .because("Domain layer should not depend on Application layer");

        rule.check(classes);
    }

    @Test
    void domainLayerShouldNotDependOnInfrastructureLayer() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat().resideInAPackage("..infrastructure..")
            .because("Domain layer should not depend on Infrastructure layer");

        rule.check(classes);
    }

    @Test
    void applicationLayerShouldNotDependOnInfrastructureLayer() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..application..")
            .should().dependOnClassesThat().resideInAPackage("..infrastructure..")
            .because("Application layer should not depend on Infrastructure layer");

        rule.check(classes);
    }

    @Test
    void hexagonalArchitectureShouldBeRespected() {
        com.tngtech.archunit.library.Architectures.LayeredArchitecture architecture = 
            com.tngtech.archunit.library.Architectures.layeredArchitecture()
                .consideringAllDependencies()
                .layer("Domain").definedBy("..domain..")
                .layer("Application").definedBy("..application..")
                .layer("Infrastructure").definedBy("..infrastructure..")
                .whereLayer("Domain").mayNotAccessAnyLayer()
                .whereLayer("Application").mayOnlyAccessLayers("Domain")
                .whereLayer("Infrastructure").mayOnlyAccessLayers("Application", "Domain");

        architecture.check(classes);
    }

    @Test
    void infrastructureLayerShouldOnlyBeAccessedByConfiguration() {
        ArchRule rule = classes()
            .that().resideInAPackage("..infrastructure..")
            .should().onlyBeAccessed().byAnyPackage(
                "..infrastructure..",
                "..infrastructure.config.."
            )
            .because("Infrastructure should only be accessed through configuration");

        rule.check(classes);
    }
}
