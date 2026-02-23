# ${projectName}

Multi-module Hexagonal Architecture project generated with Clean Architecture Generator.

## Project Structure

```
${projectName}/
├── domain/              # Domain layer - Pure business logic
│   └── src/main/java/${packagePath}/domain/
│       ├── model/       # Domain entities
│       └── port/        # Ports (interfaces)
│           ├── in/      # Input ports (use cases)
│           └── out/     # Output ports (repositories, etc.)
│
├── application/         # Application layer - Use case orchestration
│   └── src/main/java/${packagePath}/application/
│       └── usecase/     # Use case implementations
│
└── infrastructure/      # Infrastructure layer - Adapters
    └── src/main/java/${packagePath}/infrastructure/
        ├── entrypoints/ # Input adapters (REST, etc.)
        ├── drivenadapters/ # Output adapters (DB, cache, etc.)
        └── config/      # Configuration and main application
```

## Architecture

This project follows **Hexagonal Architecture** (Ports & Adapters) with a multi-module structure:

- **domain**: Contains pure business logic with no external dependencies
- **application**: Orchestrates use cases using domain ports
- **infrastructure**: Implements adapters and contains Spring Boot configuration

### Dependency Flow
```
infrastructure → application → domain
```

## Build & Run

```bash
# Build all modules
./gradlew build

# Run the application
./gradlew :infrastructure:bootRun

# Run tests
./gradlew test
```

## Adding Components

```bash
# Generate entity
./gradlew generateEntity --name=Product

# Generate use case
./gradlew generateUseCase --name=CreateProduct

# Generate output adapter
./gradlew generateOutputAdapter --type=redis --name=ProductCache

# Generate input adapter
./gradlew generateInputAdapter --type=rest --name=Product
```

## Technology Stack

- Java 21
- Spring Boot 3.2.1
- Spring WebFlux (Reactive)
- Project Reactor
- Gradle (Multi-module)

---

Generated with [Clean Architecture Generator](https://github.com/somospragma/backend-architecture-design)
