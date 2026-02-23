# Backend Architecture Design - Archetype Generator Templates

Este repositorio contiene los templates de Freemarker utilizados por el generador de arquetipos de arquitectura limpia.

## 📁 Estructura del Repositorio

```
templates/
├── adapters/                   # ⚠️ SYMLINKS (atajos de compatibilidad)
│   ├── mongodb -> ../frameworks/spring/reactive/adapters/driven-adapters/mongodb
│   ├── redis -> ../frameworks/spring/reactive/adapters/driven-adapters/redis
│   └── rest -> ../frameworks/spring/reactive/adapters/entry-points/rest
│
├── architectures/              # Definiciones de arquitecturas (estructura de carpetas)
│   ├── hexagonal-single/      # Arquitectura hexagonal en un módulo
│   ├── hexagonal-multi/       # Arquitectura hexagonal multi-módulo (3 módulos)
│   ├── hexagonal-multi-granular/  # Arquitectura hexagonal granular (6+ módulos)
│   └── onion-single/          # Arquitectura onion en un módulo
│
└── frameworks/                 # 🎯 TEMPLATES REALES (por framework y paradigma)
    ├── spring/
    │   ├── reactive/          # Spring WebFlux (reactivo)
    │   │   ├── project/       # Templates de proyecto base
    │   │   ├── domain/        # Templates de entidades de dominio
    │   │   ├── usecase/       # Templates de casos de uso
    │   │   └── adapters/
    │   │       ├── entry-points/    # Adaptadores de entrada
    │   │       │   ├── rest/        # REST API con WebFlux
    │   │       │   └── index.json
    │   │       └── driven-adapters/ # Adaptadores de salida
    │   │           ├── generic/     # Templates genéricos (Mapper, Entity)
    │   │           ├── mongodb/     # MongoDB con Spring Data Reactive
    │   │           ├── postgresql/  # PostgreSQL con R2DBC
    │   │           ├── redis/       # Redis con Lettuce Reactive
    │   │           └── index.json
    │   │
    │   └── imperative/        # Spring MVC (imperativo) - 🚧 En desarrollo
    │
    └── quarkus/               # Quarkus - 🔜 Planeado
        ├── reactive/          # Quarkus Reactive con Mutiny
        └── imperative/        # Quarkus Imperative
```

### ⚠️ Importante: Symlinks en `templates/adapters/`

La carpeta `templates/adapters/` contiene **enlaces simbólicos (symlinks)** que apuntan a los templates reales en `templates/frameworks/`. Estos symlinks sirven para:

- **Retrocompatibilidad**: Código legacy que busca en `templates/adapters/`
- **Acceso rápido**: Rutas más cortas durante desarrollo
- **Comportamiento por defecto**: Cuando no se especifica framework/paradigma

**Los templates reales están en:** `templates/frameworks/{framework}/{paradigm}/adapters/`

**Verificar symlinks:**
```bash
# Ver que son symlinks (la 'l' al inicio indica link)
ls -la templates/adapters/
# lrwxr-xr-x ... mongodb -> ../frameworks/spring/reactive/adapters/driven-adapters/mongodb

# Ver a dónde apunta un symlink
readlink templates/adapters/mongodb
# ../frameworks/spring/reactive/adapters/driven-adapters/mongodb
```

## 🎯 Nomenclatura Correcta

Este proyecto utiliza la nomenclatura estándar de Clean Architecture:

- ✅ **entry-points**: Adaptadores de entrada (REST, Kafka Consumer, etc.)
- ✅ **driven-adapters**: Adaptadores de salida (Redis, DynamoDB, Kafka Producer, etc.)

❌ **NO usar**: `adapter.in`, `adapter.out`, `input`, `output`

## 📦 Estructura de un Adaptador

Cada adaptador debe contener:

```
adaptador/
├── Adapter.java.ftl          # Implementación principal
├── Config.java.ftl           # Configuración (opcional)
├── Test.java.ftl             # Tests unitarios
└── metadata.yml              # Metadata del adaptador
```

### Ejemplo de metadata.yml

```yaml
name: redis
displayName: Redis Cache
description: Adaptador de caché con Redis
framework: spring
paradigm: reactive
type: driven-adapter  # o entry-point
version: 1.0.0
author: Pragma Team

parameters:
  required:
    - name: name
      type: string
      description: Nombre del adaptador
  optional:
    - name: ttl
      type: integer
      default: 3600

dependencies:
  gradle:
    - groupId: org.springframework.boot
      artifactId: spring-boot-starter-data-redis-reactive

files:
  - name: Adapter.java.ftl
    output: "{adapterName}RedisAdapter.java"
```

## 🚀 Uso

Los templates son descargados automáticamente por el plugin desde este repositorio.

### Modo Producción (default)
```yaml
templates:
  repository: https://github.com/somospragma/backend-architecture-design-archetype-generator-templates
  branch: main
  cache: true
```

### Modo Developer
```yaml
templates:
  mode: developer
  localPath: /ruta/local/templates
  cache: false
```

## 🤝 Contribuir

### Agregar un Nuevo Adaptador

Para agregar un nuevo adaptador, sigue estos pasos:

#### 1. Crear la Estructura de Templates

```bash
# Crear carpeta en la ubicación correcta (frameworks, NO en adapters)
mkdir -p templates/frameworks/spring/reactive/adapters/driven-adapters/postgresql

# Navegar a la carpeta
cd templates/frameworks/spring/reactive/adapters/driven-adapters/postgresql
```

#### 2. Crear los Templates (.ftl)

Crea los archivos necesarios:
- `Adapter.java.ftl` - Implementación principal
- `Entity.java.ftl` - Entidad de datos
- `Config.java.ftl` - Configuración (opcional)
- `Repository.java.ftl` - Repositorio (si aplica)
- `Test.java.ftl` - Tests unitarios
- `metadata.yml` - Metadata del adaptador
- `application-properties.yml.ftl` - Propiedades de configuración

#### 3. Crear metadata.yml

```yaml
name: postgresql
displayName: PostgreSQL R2DBC
description: Adaptador reactivo para PostgreSQL con R2DBC
framework: spring
paradigm: reactive
type: driven-adapter
version: 1.0.0

dependencies:
  gradle:
    - groupId: org.springframework.boot
      artifactId: spring-boot-starter-data-r2dbc
    - groupId: org.postgresql
      artifactId: r2dbc-postgresql

files:
  - name: Adapter.java.ftl
    output: "{entityName}RepositoryAdapter.java"
  - name: Entity.java.ftl
    output: "{entityName}Entity.java"
```

#### 4. (Opcional) Crear Symlink para Acceso Rápido

```bash
# Navegar a la carpeta de symlinks
cd templates/adapters/

# Crear el symlink
ln -s ../frameworks/spring/reactive/adapters/driven-adapters/postgresql postgresql

# Verificar que se creó correctamente
ls -la postgresql
# Debe mostrar: postgresql -> ../frameworks/spring/reactive/adapters/driven-adapters/postgresql

# Verificar a dónde apunta
readlink postgresql
# Debe mostrar: ../frameworks/spring/reactive/adapters/driven-adapters/postgresql
```

#### 5. Actualizar index.json

Agrega el nuevo adaptador al archivo `index.json`:

```json
{
  "adapters": [
    {
      "type": "redis",
      "name": "Redis Cache",
      "description": "Reactive Redis adapter for caching"
    },
    {
      "type": "postgresql",
      "name": "PostgreSQL R2DBC",
      "description": "Reactive PostgreSQL adapter with R2DBC"
    }
  ]
}
```

#### 6. Probar Localmente

```bash
# En el proyecto core, configurar modo developer
# Editar .cleanarch.yml:
templates:
  mode: developer
  localPath: /ruta/absoluta/a/templates
  cache: false

# Generar el adaptador
./gradlew generateOutputAdapter \
  --name=UserRepository \
  --entity=User \
  --type=postgresql \
  --packageName=com.test.infrastructure.driven-adapters.postgresql

# Verificar que se generó correctamente
ls -la src/main/java/com/test/infrastructure/driven-adapters/postgresql/
```

#### 7. Crear Pull Request

Una vez probado localmente:
1. Commit de los cambios
2. Push a tu fork
3. Crear Pull Request con descripción detallada

### 🔗 Trabajar con Symlinks

#### ¿Qué son los Symlinks?

Los symlinks (enlaces simbólicos) son atajos que apuntan a archivos o carpetas en otra ubicación. En este proyecto, `templates/adapters/` contiene symlinks a los templates reales en `templates/frameworks/`.

#### Crear un Symlink

```bash
# Sintaxis: ln -s <destino> <nombre_del_link>

# Ejemplo: crear symlink para mongodb
cd templates/adapters/
ln -s ../frameworks/spring/reactive/adapters/driven-adapters/mongodb mongodb
```

#### Verificar Symlinks

```bash
# Ver si es un symlink (la 'l' al inicio indica link)
ls -la templates/adapters/mongodb
# lrwxr-xr-x ... mongodb -> ../frameworks/spring/reactive/adapters/driven-adapters/mongodb

# Ver a dónde apunta
readlink templates/adapters/mongodb
# ../frameworks/spring/reactive/adapters/driven-adapters/mongodb

# Seguir el symlink y ver los archivos reales
ls -la templates/adapters/mongodb/
# Muestra los archivos en la carpeta de destino
```

#### Eliminar un Symlink

```bash
# Eliminar el symlink (NO elimina los archivos de destino)
rm templates/adapters/mongodb

# Los archivos reales permanecen seguros en:
# templates/frameworks/spring/reactive/adapters/driven-adapters/mongodb/
```

#### Consideraciones Cross-Platform

**macOS/Linux:**
- Symlinks funcionan nativamente
- Usar comando: `ln -s <destino> <nombre>`

**Windows:**
- Requiere permisos de administrador o Developer Mode habilitado
- Usar comando: `mklink /D <nombre> <destino>`
- Git en Windows maneja symlinks si `core.symlinks=true`

**Git:**
- Git almacena symlinks como archivos especiales
- Al clonar, Git recrea los symlinks automáticamente
- Asegurar `core.symlinks=true` en configuración de Git

#### Mejores Prácticas con Symlinks

**✅ HACER:**
- Crear templates reales en `frameworks/{framework}/{paradigm}/`
- Usar rutas relativas en symlinks (ej: `../frameworks/...`)
- Crear symlinks para adaptadores comúnmente usados
- Documentar symlinks en README

**❌ NO HACER:**
- Crear templates directamente en `adapters/`
- Usar rutas absolutas en symlinks (rompe portabilidad)
- Crear symlinks circulares (A → B → A)
- Commitear symlinks rotos

### Agregar Soporte para Nuevo Framework

Cuando agregues soporte para un nuevo framework (ej: Spring Imperative):

```bash
# 1. Crear estructura
mkdir -p templates/frameworks/spring/imperative/adapters/driven-adapters/mongodb

# 2. Copiar y modificar templates
# Copiar desde reactive/ y modificar para eliminar Mono/Flux

# 3. NO crear symlinks en adapters/ todavía
# Los symlinks actuales apuntan a reactive, déjalos así

# 4. El generador debe resolver templates basándose en paradigm:
# - paradigm=reactive → frameworks/spring/reactive/...
# - paradigm=imperative → frameworks/spring/imperative/...
```

Ver [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles.

## 📋 Adaptadores Disponibles

### Spring Reactive (WebFlux)

#### Entry Points (Adaptadores de Entrada)
| Adaptador | Estado | Descripción |
|-----------|--------|-------------|
| **REST API** | ✅ Disponible | Controladores REST con WebFlux, Mono/Flux |
| **GraphQL** | 🔜 Planeado | Resolvers GraphQL con Spring GraphQL |
| **gRPC** | 🔜 Planeado | Servicios gRPC con Protocol Buffers |
| **WebSocket** | 🔜 Planeado | Handlers WebSocket reactivos |

#### Driven Adapters (Adaptadores de Salida)
| Adaptador | Estado | Descripción |
|-----------|--------|-------------|
| **Redis** | ✅ Disponible | Cache con Spring Data Redis Reactive + Lettuce |
| **MongoDB** | ✅ Disponible | Base de datos NoSQL con Spring Data MongoDB Reactive |
| **PostgreSQL** | ✅ Disponible | Base de datos relacional con R2DBC |
| **REST Client** | 🚧 En desarrollo | Cliente HTTP con WebClient |
| **Kafka** | 🚧 En desarrollo | Productor/Consumidor con Reactor Kafka |
| **DynamoDB** | 🔜 Planeado | Base de datos NoSQL de AWS |
| **MySQL** | 🔜 Planeado | Base de datos relacional con R2DBC MySQL |
| **RabbitMQ** | 🔜 Planeado | Mensajería con Spring AMQP Reactive |

### Spring Imperative (MVC)

#### Entry Points (Adaptadores de Entrada)
| Adaptador | Estado | Descripción |
|-----------|--------|-------------|
| **REST API** | 🚧 En desarrollo | Controladores REST con Spring MVC |
| **GraphQL** | 🔜 Planeado | Resolvers GraphQL síncronos |

#### Driven Adapters (Adaptadores de Salida)
| Adaptador | Estado | Descripción |
|-----------|--------|-------------|
| **Redis** | 🚧 En desarrollo | Cache con Spring Data Redis |
| **MongoDB** | 🚧 En desarrollo | Base de datos NoSQL con Spring Data MongoDB |
| **PostgreSQL** | 🚧 En desarrollo | Base de datos relacional con JPA/Hibernate |
| **MySQL** | 🔜 Planeado | Base de datos relacional con JPA/Hibernate |

### Quarkus Reactive (Mutiny)

| Adaptador | Estado | Descripción |
|-----------|--------|-------------|
| **Todos** | 🔜 Planeado Q3 2026 | Adaptadores con Uni/Multi de Mutiny |

### Quarkus Imperative

| Adaptador | Estado | Descripción |
|-----------|--------|-------------|
| **Todos** | 🔜 Planeado Q4 2026 | Adaptadores síncronos para Quarkus |

**Leyenda:**
- ✅ Disponible y probado
- 🚧 En desarrollo activo
- 🔜 Planeado para futuras versiones

### Roadmap

**Q1 2026** (Actual)
- ✅ REST API (Spring Reactive)
- ✅ Redis (Spring Reactive)
- ✅ MongoDB (Spring Reactive)
- ✅ PostgreSQL (Spring Reactive)

**Q2 2026**
- 🚧 REST Client (Spring Reactive)
- 🚧 Kafka (Spring Reactive)
- 🚧 REST API (Spring Imperative)
- 🚧 Redis (Spring Imperative)

**Q3 2026**
- 🔜 GraphQL (Spring Reactive)
- 🔜 gRPC (Spring Reactive)
- 🔜 DynamoDB (Spring Reactive)
- 🔜 Quarkus Reactive (todos los adaptadores)

**Q4 2026**
- 🔜 WebSocket (Spring Reactive)
- 🔜 RabbitMQ (Spring Reactive)
- 🔜 Quarkus Imperative (todos los adaptadores)


## 📄 Licencia

Este proyecto está licenciado bajo la **Apache License 2.0** - ver el archivo [LICENSE](LICENSE) para más detalles.

```
Copyright 2025 Pragma S.A. and Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
```

### ¿Qué puedes hacer con este proyecto?

- ✅ Usar en proyectos personales y comerciales
- ✅ Modificar y crear obras derivadas
- ✅ Distribuir copias originales o modificadas
- ✅ Hacer fork y evolucionar el proyecto
- ✅ Usar en tu empresa sin restricciones

### ¿Qué debes hacer?

- 📋 Mantener los avisos de copyright y licencia
- 📋 Incluir el archivo [NOTICE](NOTICE) en distribuciones
- 📋 Documentar cambios significativos realizados
- 📋 Dar atribución al proyecto original

Ver [NOTICE](NOTICE) para información de atribución.
