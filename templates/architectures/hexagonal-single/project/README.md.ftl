# ${projectName}

Clean Architecture project generated with [Clean Architecture Generator](https://github.com/somospragma/backend-architecture-design-archetype-generator-core).

## Architecture

- **Type**: ${architecture}
- **Framework**: ${framework}
- **Paradigm**: ${paradigm}
- **Package**: ${basePackage}

## Structure

```
src/main/java/${basePackage?replace(".", "/")}/
├── domain/
│   ├── model/          # Domain entities
│   ├── port/
│   │   ├── in/         # Input ports (use cases)
│   │   └── out/        # Output ports (repositories, services)
│   └── usecase/        # Use case implementations
└── infrastructure/
    ├── adapter/
    │   ├── in/         # Input adapters (REST, GraphQL, etc.)
    │   └── out/        # Output adapters (DB, Redis, Kafka, etc.)
    └── config/         # Configuration classes
```

## Getting Started

### Prerequisites

- Java ${javaVersion}+
- Gradle 8.x

### Build

```bash
./gradlew build
```

### Run

```bash
./gradlew bootRun
```

### Test

```bash
./gradlew test
```

## Adding Components

### Generate Entity

```bash
./gradlew generateEntity --name=MyEntity --fields="id:String,name:String"
```

### Generate Use Case

```bash
./gradlew generateUseCase --name=MyUseCase
```

### Generate Output Adapter

```bash
./gradlew generateOutputAdapter --type=redis --name=MyCache
```

### Generate Input Adapter

```bash
./gradlew generateInputAdapter --type=rest --name=MyController
```

## Documentation

- [Clean Architecture Generator Docs](https://docs.clean-arch-generator.com)
- [Hexagonal Architecture Guide](https://docs.clean-arch-generator.com/guides/architectures/hexagonal)

## License

[Your License Here]
