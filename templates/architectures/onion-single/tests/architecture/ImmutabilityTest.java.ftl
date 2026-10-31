package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.lang.ArchRule;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.fields;

/**
 * Immutability rules: dependencies arrive through the constructor and never
 * change, so use cases and beans are safe to share between threads.
 *
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class ImmutabilityTest {

    private static final String SPRING_COMPONENT = "org.springframework.stereotype.Component";
    private static final String SPRING_VALUE = "org.springframework.beans.factory.annotation.Value";

    private static JavaClasses classes;

    @BeforeAll
    static void setup() {
        classes = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages("${basePackage}");
    }

    @Test
    void useCaseFieldsShouldBeFinal() {
        ArchRule rule = fields()
            .that().areDeclaredInClassesThat().resideInAPackage("..application.usecase..")
            .and().areNotStatic()
            .should().beFinal()
            .allowEmptyShould(true)
            .because("Use cases receive their gateways through the constructor and must not change them");

        rule.check(classes);
    }

    @Test
    void adapterBeanFieldsShouldBeFinal() {
        // Only Spring beans: persistence entities and DTOs inside adapters are
        // data holders that frameworks need to mutate.
        ArchRule rule = fields()
            .that().areDeclaredInClassesThat().resideInAPackage("..infrastructure..")
            .and().areDeclaredInClassesThat().areMetaAnnotatedWith(SPRING_COMPONENT)
            .and().areNotStatic()
            .and().areNotAnnotatedWith(SPRING_VALUE)
            .should().beFinal()
            .allowEmptyShould(true)
            .because("Adapters are singletons shared between threads; inject dependencies through the constructor");

        rule.check(classes);
    }
}
