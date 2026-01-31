# Backend Architecture Design - Archetype Generator Templates

Este repositorio contiene los templates de Freemarker utilizados por el generador de arquetipos de arquitectura limpia.

## 📁 Estructura del Repositorio

```
templates/
├── architectures/              # Definiciones de arquitecturas
│   ├── hexagonal/             # Arquitectura hexagonal
│   └── onion/                 # Arquitectura onion (futuro)
│
└── frameworks/                 # Templates por framework y paradigma
    ├── spring/
    │   ├── reactive/          # Spring WebFlux (reactivo)
    │   │   ├── project/       # Templates de proyecto base
    │   │   ├── adapters/
    │   │   │   ├── entry-points/    # Adaptadores de entrada
    │   │   │   │   ├── rest/        # REST API
    │   │   │   │   └── index.json
    │   │   │   └── driven-adapters/ # Adaptadores de salida
    │   │   │       ├── redis/       # Cache con Redis
    │   │   │       └── index.json
    │   │   └── usecase/       # Templates de casos de uso
    │   │
    │   └── imperative/        # Spring MVC (imperativo) - futuro
    │
    └── quarkus/               # Quarkus - futuro
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

Para agregar un nuevo adaptador:

1. Crear carpeta en `frameworks/{framework}/{paradigm}/adapters/{entry-points|driven-adapters}/{tipo}/`
2. Agregar templates (.ftl)
3. Crear metadata.yml
4. Actualizar index.json
5. Probar localmente
6. Crear Pull Request

Ver [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles.

## 📋 Adaptadores Disponibles

### Spring Reactive

#### Entry Points (Adaptadores de Entrada)
- ✅ **REST API** - Controladores REST con WebFlux

#### Driven Adapters (Adaptadores de Salida)
- ✅ **Redis** - Cache con Spring Data Redis Reactive

### Próximamente
- DynamoDB
- PostgreSQL (R2DBC)
- Kafka Producer/Consumer
- MongoDB
- Y más...
