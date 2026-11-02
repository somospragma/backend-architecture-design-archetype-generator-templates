package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.lang.ArchRule;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

/**
 * Reactive (Spring WebFlux) rules: nothing blocks the event loop.
 *
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class ParadigmRulesTest {

    private static JavaClasses classes;

    @BeforeAll
    static void setup() {
        classes = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages("${basePackage}");
    }

    @Test
    void noBlockingCallsOnPublishers() {
        ArchRule rule = noClasses()
            .should().callMethod("reactor.core.publisher.Mono", "block")
            .orShould().callMethod("reactor.core.publisher.Mono", "blockOptional")
            .orShould().callMethod("reactor.core.publisher.Flux", "blockFirst")
            .orShould().callMethod("reactor.core.publisher.Flux", "blockLast")
            .orShould().callMethod("reactor.core.publisher.Flux", "toIterable")
            .orShould().callMethod("reactor.core.publisher.Flux", "toStream")
            .allowEmptyShould(true)
            .because("Blocking a publisher stalls the event loop that serves every request");

        rule.check(classes);
    }

    @Test
    void noBlockingStacks() {
        ArchRule rule = noClasses()
            .should().dependOnClassesThat().resideInAnyPackage(
                "org.springframework.web.servlet..",
                "org.springframework.jdbc..",
                "jakarta.persistence..",
                "jakarta.servlet..")
            .orShould().dependOnClassesThat().haveFullyQualifiedName("org.springframework.web.client.RestTemplate")
            .allowEmptyShould(true)
            .because("Servlet, JDBC, JPA and RestTemplate block threads; use WebFlux, R2DBC and WebClient");

        rule.check(classes);
    }
}
