package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.lang.ArchRule;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noFields;

/**
 * Spring rules shared by every architecture: constructor injection, and each
 * Spring stereotype only in the ring it belongs to.
 *
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class FrameworkRulesTest {

    private static JavaClasses classes;

    @BeforeAll
    static void setup() {
        classes = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages("${basePackage}");
    }

    @Test
    void noFieldInjection() {
        ArchRule rule = noFields()
            .should().beAnnotatedWith("org.springframework.beans.factory.annotation.Autowired")
            .allowEmptyShould(true)
            .because("Inject dependencies through the constructor so they can be final and tested without Spring");

        rule.check(classes);
    }

    @Test
    void controllersLiveInEntryPoints() {
        ArchRule rule = classes()
            .that().areAnnotatedWith("org.springframework.web.bind.annotation.RestController")
            .or().areAnnotatedWith("org.springframework.stereotype.Controller")
            .should().resideInAPackage("..infrastructure.entrypoints..")
            .allowEmptyShould(true)
            .because("Controllers are entry points");

        rule.check(classes);
    }

    @Test
    void repositoriesLiveInDrivenAdapters() {
        ArchRule rule = classes()
            .that().areAnnotatedWith("org.springframework.stereotype.Repository")
            .or().areAssignableTo("org.springframework.data.repository.Repository")
            .should().resideInAPackage("..infrastructure.drivenadapters..")
            .allowEmptyShould(true)
            .because("Persistence belongs to driven adapters; the domain only sees its gateways");

        rule.check(classes);
    }
}
