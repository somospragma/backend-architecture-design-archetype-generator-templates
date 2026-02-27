# Comparación de Arquitecturas: Hexagonal vs Onion

## Resumen

Este documento explica las diferencias clave entre las arquitecturas Hexagonal y Onion implementadas en el generador, y cómo se reflejan en los archivos `structure.yml`.

---

## Hexagonal Architecture (Ports & Adapters)

### Filosofía
- Enfoque en **puertos** (interfaces) y **adaptadores** (implementaciones)
- Separación clara entre lógica de negocio y detalles técnicos
- Los adaptadores se conectan a puertos definidos en el dominio

### Estructura de Packages

```
src/main/java/
├── domain/
│   ├── model/              # Entidades de dominio
│   ├── port/
│   │   ├── in/            # Puertos de entrada (use cases)
│   │   └── out/           # Puertos de salida (repositorios, servicios externos)
├── application/
│   └── usecase/           # Implementaciones de use cases
└── infrastructure/
    ├── entry-points/      # Adaptadores de entrada (REST, GraphQL, etc.)
    ├── driven-adapters/   # Adaptadores de salida (DB, APIs externas, etc.)
    └── config/            # Configuración de Spring
```

### Características en structure.yml

```yaml
architecture: "hexagonal-single"
multiModule: false

adapterPaths:
  driven: "infrastructure/driven-adapters/{name}"
  driving: "infrastructure/entry-points/{name}"

packageMappings:
  replacements:
    entry-points: "entrypoints"
    driven-adapters: "drivenadapters"

entityModule: "domain"
useCaseModule: "application"

moduleMetadata:
  - name: "domain"
    packageTypes:
      model: "domain/model"
      portIn: "domain/port/in"
      portOut: "domain/port/out"
  - name: "application"
    packageTypes:
      usecase: "application/usecase"
  - name: "infrastructure"
    packageTypes:
      entryPoints: "infrastructure/entry-points"
      drivenAdapters: "infrastructure/driven-adapters"
```

### Flujo de Dependencias
```
Infrastructure → Application → Domain
(Adapters)    → (Use Cases) → (Entities & Ports)
```

---

## Onion Architecture

### Filosofía
- Enfoque en **capas concéntricas** con el dominio en el centro
- Dependencias apuntan hacia adentro (hacia el dominio)
- Énfasis en la inversión de dependencias y el aislamiento del dominio

### Estructura de Packages

```
src/main/java/
├── core/
│   ├── domain/                    # Capa más interna - Entidades de dominio
│   └── application/
│       ├── service/               # Servicios de aplicación (use cases)
│       └── port/                  # Puertos (interfaces para adapters)
└── infrastructure/
    ├── adapter/
    │   ├── in/                    # Adaptadores de entrada
    │   └── out/                   # Adaptadores de salida
    └── config/                    # Configuración de Spring
```

### Características en structure.yml

```yaml
architecture: "onion-single"
multiModule: false

adapterPaths:
  driven: "infrastructure/adapter/out/{name}"
  driving: "infrastructure/adapter/in/{name}"

packageMappings:
  replacements:
    adapter-in: "adapter.in"
    adapter-out: "adapter.out"

entityModule: "core"
useCaseModule: "core"

moduleMetadata:
  - name: "core"
    packageTypes:
      model: "core/domain"
      portIn: "core/application/port"
      portOut: "core/application/port"
      usecase: "core/application/service"
  - name: "infrastructure"
    packageTypes:
      entryPoints: "infrastructure/adapter/in"
      drivenAdapters: "infrastructure/adapter/out"

layerDependencies:
  domain: []                    # Sin dependencias
  application: ["domain"]       # Solo depende de domain
  infrastructure: ["domain", "application"]  # Depende de ambas
```

### Flujo de Dependencias
```
Infrastructure → Application → Domain
(Adapters)    → (Services)   → (Entities)
     ↓              ↓             ↓
   Outer         Middle        Inner
```

---

## Comparación Lado a Lado

| Aspecto | Hexagonal | Onion |
|---------|-----------|-------|
| **Concepto Central** | Puertos y Adaptadores | Capas Concéntricas |
| **Dominio** | `domain/model` | `core/domain` |
| **Use Cases** | `application/usecase` | `core/application/service` |
| **Puertos** | `domain/port/in` y `domain/port/out` | `core/application/port` |
| **Adaptadores Entrada** | `infrastructure/entry-points` | `infrastructure/adapter/in` |
| **Adaptadores Salida** | `infrastructure/driven-adapters` | `infrastructure/adapter/out` |
| **Énfasis** | Separación puerto/adaptador | Capas y dependencias hacia adentro |
| **Naming** | Más explícito (entry-points, driven-adapters) | Más simple (in, out) |

---

## Elementos Comunes en structure.yml

Ambas arquitecturas requieren los siguientes elementos en `structure.yml`:

### 1. adapterPaths
Define dónde se generan los adaptadores:
```yaml
adapterPaths:
  driven: "ruta/para/adaptadores/salida/{name}"
  driving: "ruta/para/adaptadores/entrada/{name}"
```

### 2. packageMappings
Transforma paths del filesystem a nombres de packages Java:
```yaml
packageMappings:
  rules:
    removeHyphens: true
    slashToDot: true
  replacements:
    entry-points: "entrypoints"
```

### 3. entityModule y useCaseModule
Indica dónde generar entidades y use cases:
```yaml
entityModule: "domain"      # o "core" para onion
useCaseModule: "application" # o "core" para onion
```

### 4. moduleMetadata
Define los tipos de packages para cada módulo:
```yaml
moduleMetadata:
  - name: "domain"
    path: "."
    packageTypes:
      model: "domain/model"
      portIn: "domain/port/in"
      portOut: "domain/port/out"
```

---

## Variables de Template

Ambas arquitecturas usan las mismas variables en los templates FreeMarker:

### BeanConfiguration.java.ftl

```java
@Configuration
@ComponentScan(
    basePackages = {
        "${basePackage}.application.usecase",  // o core.application
        "${drivenAdaptersPackage}",            // Generado dinámicamente
        "${drivingAdaptersPackage}"            // Generado dinámicamente
    }
)
public class BeanConfiguration { }
```

Las variables `drivenAdaptersPackage` y `drivingAdaptersPackage` se generan automáticamente desde:
- `adapterPaths.driven` → `drivenAdaptersPackage`
- `adapterPaths.driving` → `drivingAdaptersPackage`

Aplicando `packageMappings` para convertir paths a packages Java.

---

## Cuándo Usar Cada Una

### Hexagonal Architecture
✅ Cuando quieres énfasis explícito en puertos y adaptadores  
✅ Equipos que prefieren nomenclatura más descriptiva  
✅ Proyectos con muchos tipos diferentes de adaptadores  
✅ Cuando la separación puerto/adaptador es crítica para el negocio  

### Onion Architecture
✅ Cuando quieres énfasis en capas y dependencias  
✅ Equipos familiarizados con DDD (Domain-Driven Design)  
✅ Proyectos donde el dominio es muy rico y complejo  
✅ Cuando quieres forzar reglas estrictas de dependencias entre capas  

---

## Conclusión

Ambas arquitecturas logran el mismo objetivo: **aislar la lógica de negocio de los detalles técnicos**. La diferencia principal está en:

- **Hexagonal**: Enfoque en la interfaz (puertos) entre capas
- **Onion**: Enfoque en las capas mismas y sus dependencias

El generador soporta ambas mediante configuración en `structure.yml`, permitiendo que el mismo código del plugin funcione para ambas arquitecturas de manera dinámica.
