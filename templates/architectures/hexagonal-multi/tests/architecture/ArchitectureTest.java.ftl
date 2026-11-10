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
import static com.tngtech.archunit.library.Architectures.layeredArchitecture;

/**
 * Hexagonal architecture (ports and adapters) rules:
 *
 *   domain.model          entities and value objects
 *   domain.ports          input ports (I...UseCase) and output ports (I...Gateway)
 *   domain.usecases       use cases, implement input ports and use output ports
 *   infrastructure        entry points call input ports; driven adapters
 *                         implement output ports; config wires everything
 *
 * Rules shared with other architectures live in DomainPurityTest,
 * AdapterRulesTest, NamingConventionTest, ImmutabilityTest and CodingRulesTest.
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
    void layersOnlyAccessWhatTheyAreAllowedTo() {
        layeredArchitecture()
            .consideringOnlyDependenciesInLayers()
            .withOptionalLayers(true)
            .layer("Model").definedBy("..domain.model..")
            .layer("Ports").definedBy("..domain.ports..")
            .layer("UseCases").definedBy("..domain.usecases..")
            .layer("EntryPoints").definedBy("..infrastructure.entrypoints..")
            .layer("DrivenAdapters").definedBy("..infrastructure.drivenadapters..")
            .layer("Config").definedBy("..infrastructure.config..")
            .whereLayer("Ports").mayOnlyBeAccessedByLayers("UseCases", "EntryPoints", "DrivenAdapters", "Config")
            .whereLayer("UseCases").mayOnlyBeAccessedByLayers("Config")
            .whereLayer("EntryPoints").mayNotBeAccessedByAnyLayer()
            .whereLayer("DrivenAdapters").mayNotBeAccessedByAnyLayer()
            .because("Adapters meet only at the ports; nothing depends on an adapter")
            .check(classes);
    }

    @Test
    void modelDoesNotDependOnPortsOrUseCases() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..domain.model..")
            .should().dependOnClassesThat().resideInAnyPackage("..domain.ports..", "..domain.usecases..")
            .allowEmptyShould(true)
            .because("The model is the innermost part of the domain");

        rule.check(classes);
    }

    @Test
    void portsDoNotDependOnUseCases() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..domain.ports..")
            .should().dependOnClassesThat().resideInAPackage("..domain.usecases..")
            .allowEmptyShould(true)
            .because("Ports are contracts; use cases implement them");

        rule.check(classes);
    }

    @Test
    void useCasesImplementAnInputPort() {
        ArchRule rule = classes()
            .that().resideInAPackage("..domain.usecases..")
            .and().haveSimpleNameEndingWith("UseCase")
            .and().areNotInterfaces()
            .should(IMPLEMENT_AN_INPUT_PORT)
            .allowEmptyShould(true)
            .because("Entry points depend on the input port, so the use case can change without touching them");

        rule.check(classes);
    }

    private static final ArchCondition<JavaClass> IMPLEMENT_AN_INPUT_PORT =
        new ArchCondition<>("implement an input port of domain.ports") {
            @Override
            public void check(JavaClass item, ConditionEvents events) {
                boolean implementsPort = item.getAllRawInterfaces().stream()
                    .anyMatch(type -> type.getPackageName().endsWith(".domain.ports")
                        && type.getSimpleName().endsWith("UseCase"));
                if (!implementsPort) {
                    events.add(SimpleConditionEvent.violated(item,
                        item.getName() + " does not implement an I...UseCase port of domain.ports"));
                }
            }
        };
}
