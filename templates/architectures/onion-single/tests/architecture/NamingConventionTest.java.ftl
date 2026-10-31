package ${basePackage}.architecture;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.lang.ArchRule;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.fields;

/**
 * Naming convention tests to ensure domain purity and KB compliance.
 * Validates that domain classes don't use technical names or suffixes,
 * and that gateways, use cases and adapters follow KB naming conventions.
 * 
 * DO NOT MODIFY OR DELETE THIS FILE.
 * validateStructure regenerates it from the templates.
 */
class NamingConventionTest {

    private static JavaClasses classes;

    // Forbidden suffixes in domain classes
    private static final String[] FORBIDDEN_SUFFIXES = {
        "DTO", "Dto", "dto",
        "Request", "request",
        "Response", "response",
        "Entity", "entity"  // JPA Entity suffix
    };

    // Forbidden technical names in domain classes
    private static final String[] FORBIDDEN_NAMES = {
        "rabbit", "Rabbit", "RABBIT",
        "sqs", "Sqs", "SQS",
        "sns", "Sns", "SNS",
        "ibm", "Ibm", "IBM",
        "dynamo", "Dynamo", "DYNAMO",
        "aws", "Aws", "AWS",
        "mysql", "Mysql", "MySQL", "MYSQL",
        "postgres", "Postgres", "PostgreSQL", "POSTGRES",
        "redis", "Redis", "REDIS",
        "mongo", "Mongo", "MongoDB", "MONGO",
        "rsocket", "RSocket", "RSOCKET",
        "r2dbc", "R2dbc", "R2DBC",
        "http", "Http", "HTTP",
        "kms", "Kms", "KMS",
        "s3", "S3",
        "graphql", "GraphQL", "GRAPHQL",
        "kafka", "Kafka", "KAFKA",
        "rest", "Rest", "REST",
        "soap", "Soap", "SOAP",
        "grpc", "Grpc", "GRPC", "gRPC"
    };

    @BeforeAll
    static void setup() {
        classes = new ClassFileImporter()
            .withImportOption(ImportOption.Predefined.DO_NOT_INCLUDE_TESTS)
            .importPackages("${basePackage}");
    }

    @Test
    void domainClassesShouldNotHaveTechnicalSuffixes() {
        for (String suffix : FORBIDDEN_SUFFIXES) {
            ArchRule rule = classes()
                .that().resideInAPackage("..domain..")
                .should().haveSimpleNameNotEndingWith(suffix)
                .allowEmptyShould(true)
                .because("Domain classes should not use technical suffixes like " + suffix);

            rule.check(classes);
        }
    }

    @Test
    void domainClassesShouldNotContainTechnicalNames() {
        for (String technicalName : FORBIDDEN_NAMES) {
            ArchRule rule = classes()
                .that().resideInAPackage("..domain..")
                .should().haveSimpleNameNotContaining(technicalName)
                .allowEmptyShould(true)
                .because("Domain classes should not contain technical names like " + technicalName);

            rule.check(classes);
        }
    }

    @Test
    void domainFieldsShouldNotContainTechnicalNames() {
        for (String technicalName : FORBIDDEN_NAMES) {
            ArchRule rule = fields()
                .that().areDeclaredInClassesThat().resideInAPackage("..domain..")
                .should().haveNameNotContaining(technicalName)
                .allowEmptyShould(true)
                .because("Domain fields should not contain technical names like " + technicalName);

            rule.check(classes);
        }
    }

    @Test
    void domainGatewaysShouldHaveIPrefix() {
        ArchRule rule = classes()
            .that().resideInAPackage("..domain.gateway..")
            .and().areInterfaces()
            .should().haveSimpleNameStartingWith("I")
            .allowEmptyShould(true)
            .because("Gateway interfaces must have the I prefix per KB Limit 006");

        rule.check(classes);
    }

    @Test
    void domainGatewaysShouldHaveGatewaySuffix() {
        ArchRule rule = classes()
            .that().resideInAPackage("..domain.gateway..")
            .and().areInterfaces()
            .should().haveSimpleNameEndingWith("Gateway")
            .allowEmptyShould(true)
            .because("Gateway interfaces must have the Gateway suffix per KB naming conventions");

        rule.check(classes);
    }

    @Test
    void useCasesShouldEndWithUseCaseSuffix() {
        ArchRule rule = classes()
            .that().resideInAPackage("..application.usecase..")
            .and().areTopLevelClasses()
            .should().haveSimpleNameEndingWith("UseCase")
            .allowEmptyShould(true)
            .because("Use case classes must end with UseCase suffix per KB naming conventions");

        rule.check(classes);
    }

    @Test
    void adapterClassesShouldEndWithAdapterSuffix() {
        // Adapters contain more than the adapter class itself (entities, DTOs,
        // gRPC services, scheduled tasks, consumers...). Each top-level class must
        // end with the suffix of its role; nested classes (builders, records) and
        // protobuf-generated code are out of scope.
        ArchRule rule = classes()
            .that().resideInAnyPackage("..drivenadapters..", "..entrypoints..")
            .and().resideOutsideOfPackage("..proto..")
            .and().areTopLevelClasses()
            .and().areNotInterfaces()
            .should().haveNameMatching(".*(Adapter|Controller|Router|Handler|Config|Mapper|MapperImpl|Properties"
                + "|Entity|Repository|DTO|Dto|Request|Response|GrpcService|ScheduledTask"
                + "|Consumer|Producer|Listener)")
            .allowEmptyShould(true)
            .because("Adapter classes must end with the suffix of their role per KB naming conventions");

        rule.check(classes);
    }
}
