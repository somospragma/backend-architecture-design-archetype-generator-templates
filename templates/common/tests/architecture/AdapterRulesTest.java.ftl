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
import static com.tngtech.archunit.library.dependencies.SlicesRuleDefinition.slices;

/**
 * Rules shared by every architecture about adapters: entry points and driven
 * adapters reach each other only through the domain, each adapter is
 * self-contained, and driven adapters implement the interfaces the domain
 * declares (ports in hexagonal, gateways in onion).
 *
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class AdapterRulesTest {

    private static JavaClasses classes;

    @BeforeAll
    static void setup() {
        classes = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages("${basePackage}");
    }

    @Test
    void domainInterfacesAreInterfaces() {
        ArchRule rule = classes()
            .that().resideInAnyPackage("..domain.ports..", "..domain.gateway..")
            .should().beInterfaces()
            .allowEmptyShould(true)
            .because("Ports and gateways describe contracts; adapters and use cases provide the implementation");

        rule.check(classes);
    }

    @Test
    void entryPointsDoNotUseDrivenAdapters() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..infrastructure.entrypoints..")
            .should().dependOnClassesThat().resideInAPackage("..infrastructure.drivenadapters..")
            .allowEmptyShould(true)
            .because("Entry points reach driven adapters only through use cases and domain interfaces");

        rule.check(classes);
    }

    @Test
    void drivenAdaptersDoNotCallEntryPointsOrUseCases() {
        ArchRule rule = noClasses()
            .that().resideInAPackage("..infrastructure.drivenadapters..")
            .should().dependOnClassesThat().resideInAnyPackage(
                "..infrastructure.entrypoints..",
                "..domain.usecases..",
                "..application..")
            .allowEmptyShould(true)
            .because("Driven adapters are called by use cases, never the other way around");

        rule.check(classes);
    }

    @Test
    void adaptersDoNotDependOnEachOther() {
        slices()
            .matching("..infrastructure.(*).(*)..")
            .namingSlices("$1 adapter $2")
            .should().notDependOnEachOther()
            .allowEmptyShould(true)
            .because("Each adapter is self-contained, so it can be replaced or removed on its own")
            .check(classes);
    }

    @Test
    void drivenAdaptersImplementADomainInterface() {
        ArchRule rule = classes()
            .that().resideInAPackage("..infrastructure.drivenadapters..")
            .and().haveSimpleNameEndingWith("Adapter")
            .and().areNotInterfaces()
            .should(IMPLEMENT_A_DOMAIN_INTERFACE)
            .allowEmptyShould(true)
            .because("Use cases reach the outside world only through interfaces declared in the domain");

        rule.check(classes);
    }

    private static final ArchCondition<JavaClass> IMPLEMENT_A_DOMAIN_INTERFACE =
        new ArchCondition<>("implement an interface of the domain") {
            @Override
            public void check(JavaClass item, ConditionEvents events) {
                boolean implementsDomainInterface = item.getAllRawInterfaces().stream()
                    .anyMatch(type -> type.getPackageName().contains(".domain."));
                if (!implementsDomainInterface) {
                    events.add(SimpleConditionEvent.violated(item,
                        item.getName() + " does not implement any interface of the domain"));
                }
            }
        };
}
