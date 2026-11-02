package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.lang.ArchRule;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

/**
 * Rules shared by every architecture: business logic (domain and use cases)
 * stays free of frameworks and infrastructure, so it can be tested and changed
 * without touching technology.
 *
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class DomainPurityTest {

    private static final String[] FRAMEWORK_PACKAGES = {
        "org.springframework..",
        "io.quarkus..",
        "jakarta..",
        "javax.persistence..",
        "org.hibernate..",
        "tools.jackson..",
        "com.fasterxml.jackson..",
        "software.amazon..",
        "com.mongodb..",
        "org.bson..",
        "io.r2dbc..",
        "io.grpc..",
        "com.google.protobuf..",
        "graphql..",
<#if !(isReactive!false)>
        // Imperative project: reactive types have no place in business logic
        "reactor..",
</#if>
    };

    private static JavaClasses classes;

    @BeforeAll
    static void setup() {
        classes = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages("${basePackage}");
    }

    @Test
    void domainIsFreeOfFrameworks() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat().resideInAnyPackage(FRAMEWORK_PACKAGES)
            .allowEmptyShould(true)
            .because("The domain must not depend on frameworks, drivers or SDKs");

        rule.check(classes);
    }

    @Test
    void applicationLayerIsFreeOfFrameworks() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..application..")
            .should().dependOnClassesThat().resideInAnyPackage(FRAMEWORK_PACKAGES)
            .allowEmptyShould(true)
            .because("Use cases are plain classes; UseCasesConfig registers them as beans");

        rule.check(classes);
    }

    @Test
    void domainDoesNotDependOnInfrastructure() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat().resideInAPackage("..infrastructure..")
            .allowEmptyShould(true)
            .because("Infrastructure depends on the domain, never the other way around");

        rule.check(classes);
    }
}
