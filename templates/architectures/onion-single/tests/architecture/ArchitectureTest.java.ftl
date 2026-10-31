package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClass;
import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.lang.ArchCondition;
import com.tngtech.archunit.lang.ArchRule;
import com.tngtech.archunit.lang.ConditionEvents;
import com.tngtech.archunit.lang.SimpleConditionEvent;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;
import static com.tngtech.archunit.library.Architectures.onionArchitecture;
import static com.tngtech.archunit.library.dependencies.SlicesRuleDefinition.slices;

/**
 * Onion architecture rules. Rings, from the core outwards:
 *
 *   domain.model          entities and value objects, depends on nothing
 *   domain.gateway        interfaces for what the domain needs from outside
 *   application.usecase   use cases, orchestrate the domain
 *   infrastructure        entry points (call use cases) and driven adapters
 *                         (implement domain gateways)
 *
 * Dependencies only point inwards, and the inner rings stay free of frameworks
 * so business logic can be tested and changed without touching technology.
 *
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class ArchitectureTest {

    private static final String[] FRAMEWORK_PACKAGES = {
        "org.springframework..",
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
        // Imperative project: reactive types have no place in the core
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

    @Test
    void domainIsFreeOfFrameworks() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat().resideInAnyPackage(FRAMEWORK_PACKAGES)
            .allowEmptyShould(true)
            .because("The domain is the core: it must not depend on frameworks, drivers or SDKs");

        rule.check(classes);
    }

    @Test
    void useCasesAreFreeOfFrameworks() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..application..")
            .should().dependOnClassesThat().resideInAnyPackage(FRAMEWORK_PACKAGES)
            .allowEmptyShould(true)
            .because("Use cases are plain classes; UseCasesConfig registers them as beans");

        rule.check(classes);
    }

    @Test
    void domainGatewaysAreInterfaces() {
        ArchRule rule = classes()
            .that().resideInAPackage("..domain.gateway..")
            .should().beInterfaces()
            .allowEmptyShould(true)
            .because("Gateways describe what the domain needs; driven adapters provide the implementation");

        rule.check(classes);
    }

    @Test
    void drivenAdaptersImplementADomainGateway() {
        ArchRule rule = classes()
            .that().resideInAPackage("..infrastructure.drivenadapters..")
            .and().haveSimpleNameEndingWith("Adapter")
            .and().areNotInterfaces()
            .should(IMPLEMENT_A_DOMAIN_GATEWAY)
            .allowEmptyShould(true)
            .because("Use cases reach the outside world only through domain gateways");

        rule.check(classes);
    }

    @Test
    void drivenAdaptersDoNotCallUseCases() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..infrastructure.drivenadapters..")
            .should().dependOnClassesThat().resideInAPackage("..application..")
            .allowEmptyShould(true)
            .because("Driven adapters are called by use cases, never the other way around");

        rule.check(classes);
    }

    @Test
    void topLevelPackagesAreFreeOfCycles() {
        slices()
            .matching("${basePackage}.(*)..")
            .should().beFreeOfCycles()
            .allowEmptyShould(true)
            .check(classes);
    }

    private static final ArchCondition<JavaClass> IMPLEMENT_A_DOMAIN_GATEWAY =
        new ArchCondition<>("implement a domain gateway") {
            @Override
            public void check(JavaClass item, ConditionEvents events) {
                boolean implementsGateway = item.getAllRawInterfaces().stream()
                    .anyMatch(type -> type.getPackageName().contains(".domain.gateway"));
                if (!implementsGateway) {
                    events.add(SimpleConditionEvent.violated(item,
                        item.getName() + " does not implement any interface of domain.gateway"));
                }
            }
        };
}
