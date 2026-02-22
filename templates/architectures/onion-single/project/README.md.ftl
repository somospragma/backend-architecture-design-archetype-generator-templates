# ${projectName}

Clean Architecture project using Onion Architecture pattern.

## Architecture

- **Framework**: ${framework}
- **Paradigm**: ${paradigm}
- **Architecture**: Onion Architecture

## Project Structure

```
src/main/java/${basePackage?replace('.', '/')}/
├── core/                          # Core business logic (innermost layers)
│   ├── domain/                   # Domain layer - Entities and Value Objects
│   │   ├── model/               # Domain entities (business objects)
│   │   └── exception/           # Domain-specific exceptions
│   └── application/              # Application layer - Use cases and ports
│       ├── service/             # Application services (use case implementations)
│       └── port/                # Port interfaces
│           ├── in/             # Input ports (use cases)
│           └── out/            # Output ports (repositories, external services)
└── infrastructure/               # Infrastructure layer (outermost layer)
    ├── adapter/                 # Adapters implementing ports
    │   ├── in/                 # Driving adapters (REST, GraphQL, messaging)
    │   └── out/                # Driven adapters (DB, cache, external APIs)
    └── config/                  # Configuration classes
```

## Onion Architecture Principles

The Onion Architecture organizes code in concentric layers, with dependencies pointing inward:

### 1. Domain Layer (Center)
- **Location**: `core/domain/`
- **Purpose**: Contains enterprise business rules and domain entities
- **Dependencies**: None - completely independent
- **Contains**:
  - Domain entities (business objects with identity)
  - Value objects (immutable objects without identity)
  - Domain events
  - Domain exceptions

### 2. Application Layer
- **Location**: `core/application/`
- **Purpose**: Contains application-specific business rules and use cases
- **Dependencies**: Only depends on Domain layer
- **Contains**:
  - Use case implementations (application services)
  - Input ports (interfaces for use cases)
  - Output ports (interfaces for external dependencies)
  - Application-specific exceptions

### 3. Infrastructure Layer (Outer)
- **Location**: `infrastructure/`
- **Purpose**: Contains framework-specific implementations and external integrations
- **Dependencies**: Depends on both Domain and Application layers
- **Contains**:
  - Driving adapters (REST controllers, message consumers)
  - Driven adapters (database repositories, external API clients)
  - Configuration classes
  - Framework-specific code

## Dependency Rules

The Onion Architecture enforces strict dependency rules:

```
┌─────────────────────────────────────────┐
│        Infrastructure Layer             │  ← Depends on Application & Domain
│  ┌───────────────────────────────────┐  │
│  │     Application Layer             │  │  ← Depends on Domain only
│  │  ┌─────────────────────────────┐  │  │
│  │  │     Domain Layer            │  │  │  ← No dependencies
│  │  │   (Entities, Value Objects) │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

**Key Rules**:
- Domain layer has NO dependencies on any other layer
- Application layer depends ONLY on Domain layer
- Infrastructure layer depends on Application and Domain layers
- Dependencies always point INWARD toward the domain

## Data Flow Example

Here's how data flows through the layers in a typical request:

```
1. HTTP Request
   ↓
2. REST Controller (infrastructure/adapter/in)
   ↓
3. Use Case Interface (core/application/port/in)
   ↓
4. Use Case Implementation (core/application/service)
   ↓
5. Repository Interface (core/application/port/out)
   ↓
6. Repository Implementation (infrastructure/adapter/out)
   ↓
7. Database
```

**Example**: Creating an order

```
OrderController (in)
  → CreateOrderUseCase (port/in)
    → CreateOrderService (service)
      → OrderRepository (port/out)
        → JpaOrderRepository (out)
          → Database
```

## Component Placement Guidelines

### Where to Add Each Component Type

#### Domain Entities
- **Location**: `core/domain/model/`
- **Example**: `Order.java`, `Customer.java`
- **Purpose**: Core business objects with identity and lifecycle

#### Value Objects
- **Location**: `core/domain/model/`
- **Example**: `Money.java`, `Address.java`
- **Purpose**: Immutable objects without identity

#### Use Case Interfaces (Input Ports)
- **Location**: `core/application/port/in/`
- **Example**: `CreateOrderUseCase.java`, `GetOrderUseCase.java`
- **Purpose**: Define what the application can do

#### Use Case Implementations
- **Location**: `core/application/service/`
- **Example**: `CreateOrderService.java`, `GetOrderService.java`
- **Purpose**: Implement business logic and orchestrate domain objects

#### Repository Interfaces (Output Ports)
- **Location**: `core/application/port/out/`
- **Example**: `OrderRepository.java`, `CustomerRepository.java`
- **Purpose**: Define contracts for data persistence

#### REST Controllers (Driving Adapters)
- **Location**: `infrastructure/adapter/in/rest/`
- **Example**: `OrderController.java`
- **Purpose**: Handle HTTP requests and responses

#### Database Repositories (Driven Adapters)
- **Location**: `infrastructure/adapter/out/persistence/`
- **Example**: `JpaOrderRepository.java`
- **Purpose**: Implement data persistence using specific technology

#### External API Clients (Driven Adapters)
- **Location**: `infrastructure/adapter/out/external/`
- **Example**: `PaymentGatewayClient.java`
- **Purpose**: Integrate with external services

#### Configuration Classes
- **Location**: `infrastructure/config/`
- **Example**: `BeanConfiguration.java`, `SecurityConfig.java`
- **Purpose**: Framework-specific configuration

## Getting Started

### Prerequisites

- Java 21
- Gradle 8.5+
<#if framework == "spring">
- Spring Boot 3.2+
</#if>

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

## Available Gradle Tasks

### Generate Use Case
```bash
./gradlew generateUseCase --name=CreateOrder --packageName=${basePackage}.core.application.port.in --methods=execute:Order:request:CreateOrderRequest
```

### Generate Entity
```bash
./gradlew generateEntity --name=Order --packageName=${basePackage}.core.domain.model --fields=customerId:String,amount:Double
```

### Generate Output Adapter (Driven Adapter)
```bash
./gradlew generateOutputAdapter --name=OrderRepository --type=jpa --packageName=${basePackage}.infrastructure.adapter.out.persistence --entity=Order
```

### Generate Input Adapter (Driving Adapter)
```bash
./gradlew generateInputAdapter --name=OrderController --type=rest --packageName=${basePackage}.infrastructure.adapter.in.rest --useCase=CreateOrder
```

## Benefits of Onion Architecture

1. **Clear Separation of Concerns**: Each layer has a specific responsibility
2. **Testability**: Core business logic can be tested without infrastructure
3. **Framework Independence**: Domain and application layers are framework-agnostic
4. **Flexibility**: Easy to swap implementations (e.g., change database or web framework)
5. **Maintainability**: Changes in outer layers don't affect inner layers
6. **Domain-Centric**: Business logic is at the center, not the database or framework

## When to Use Onion Architecture

Onion Architecture is ideal for:
- Complex business domains with rich business logic
- Long-lived applications that need to adapt to changing requirements
- Projects where business rules are more important than technical concerns
- Applications that need to support multiple interfaces (REST, GraphQL, CLI)
- Systems that require high testability and maintainability

## Learn More

- [Onion Architecture by Jeffrey Palermo](https://jeffreypalermo.com/2008/07/the-onion-architecture-part-1/)
- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Hexagonal Architecture (Ports & Adapters)](https://alistair.cockburn.us/hexagonal-architecture/)

## License

MIT
