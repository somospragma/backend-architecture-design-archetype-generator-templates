# Guía: Agregar una Nueva Arquitectura

Esta guía explica cómo agregar una nueva arquitectura al generador.

## 📋 Estructura Requerida

### Para Single Module

```
templates/architectures/mi-arquitectura-single/
├── structure.yml          # Define la arquitectura
└── project/              # Templates del proyecto raíz
    ├── build.gradle.kts.ftl
    ├── settings.gradle.kts.ftl
    ├── .gitignore.ftl
    ├── README.md.ftl
    └── BeanConfiguration.java.ftl (opcional)
```

### Para Multi Module

```
templates/architectures/mi-arquitectura-multi/
├── structure.yml          # Define la arquitectura
├── project/              # Templates del proyecto raíz
│   ├── build.gradle.kts.ftl
│   ├── settings.gradle.kts.ftl
│   ├── .gitignore.ftl
│   ├── README.md.ftl
│   └── BeanConfiguration.java.ftl
│
└── modules/              # Templates de cada módulo
    ├── domain/
    │   └── build.gradle.kts.ftl
    ├── application/
    │   └── build.gradle.kts.ftl
    └── infrastructure/
        └── build.gradle.kts.ftl
```

## 📝 Formato del structure.yml

### Single Module

```yaml
name: "Mi Arquitectura Single"
description: "Descripción de la arquitectura"
type: "mi-arquitectura-single"
multiModule: false
moduleType: "single"

# Define los paquetes que se crearán
packages:
  - "domain/model"
  - "domain/port/in"
  - "domain/port/out"
  - "application/usecase"
  - "infrastructure/entrypoints/rest"
  - "infrastructure/drivenadapters"
  - "infrastructure/config"
```

### Multi Module

```yaml
name: "Mi Arquitectura Multi"
description: "Arquitectura con múltiples módulos"
type: "mi-arquitectura-multi"
multiModule: true
moduleType: "multi"

# Define los módulos
modules:
  - name: "domain"
    path: "domain"
    description: "Domain layer - Pure business logic"
    dependencies: []
    packages:
      - "model"
      - "port/in"
      - "port/out"
  
  - name: "application"
    path: "application"
    description: "Application layer - Use case orchestration"
    dependencies:
      - "domain"
    packages:
      - "usecase"
  
  - name: "infrastructure"
    path: "infrastructure"
    description: "Infrastructure layer - Adapters and technical details"
    dependencies:
      - "domain"
      - "application"
    packages:
      - "entrypoints/rest"
      - "drivenadapters"
      - "config"
```

## ✅ Reglas Importantes

1. **Nombre del tipo**: El campo `type` debe coincidir con el nombre de la carpeta (en kebab-case)
   - Carpeta: `hexagonal-multi` → `type: "hexagonal-multi"`

2. **Multi Module**: Si `multiModule: true`, debes crear la carpeta `modules/`

3. **Module Type**: Puede ser:
   - `"single"` - Un solo módulo
   - `"multi"` - 3 módulos (domain, application, infrastructure)
   - `"multi-granular"` - Módulos muy granulares (cada adaptador es un módulo)

4. **Dependencias**: En `modules`, el orden importa. Los módulos sin dependencias van primero.

5. **Packages**: Define la estructura de paquetes que se creará dentro de cada módulo.

## 🎯 Ejemplos Reales

### Ejemplo 1: Hexagonal Single (Ya implementado)

```
templates/architectures/hexagonal-single/
├── structure.yml          # multiModule: false
└── project/
    ├── build.gradle.kts.ftl
    ├── settings.gradle.kts.ftl
    ├── .gitignore.ftl
    ├── README.md.ftl
    └── BeanConfiguration.java.ftl
```

### Ejemplo 2: Hexagonal Multi (Ya implementado)

```
templates/architectures/hexagonal-multi/
├── structure.yml          # multiModule: true, moduleType: "multi"
├── project/
│   ├── build.gradle.kts.ftl
│   ├── settings.gradle.kts.ftl
│   ├── .gitignore.ftl
│   ├── README.md.ftl
│   └── BeanConfiguration.java.ftl
└── modules/
    ├── domain/
    │   └── build.gradle.kts.ftl
    ├── application/
    │   └── build.gradle.kts.ftl
    └── infrastructure/
        └── build.gradle.kts.ftl
```

## 🔧 Variables Disponibles en Templates

Los templates (`.ftl`) tienen acceso a estas variables:

### Variables del Proyecto
- `${projectName}` - Nombre del proyecto (ej: "payment-service")
- `${projectNamePascalCase}` - Nombre en PascalCase (ej: "PaymentService")
- `${basePackage}` - Paquete base (ej: "com.pragma.payment")
- `${packagePath}` - Ruta del paquete (ej: "com/pragma/payment")
- `${groupId}` - Group ID (igual a basePackage)
- `${version}` - Versión del proyecto (ej: "0.0.1-SNAPSHOT")

### Variables de Arquitectura
- `${architecture}` - Tipo de arquitectura (ej: "hexagonal-multi")
- `${architectureType}` - Enum de arquitectura

### Variables de Framework
- `${framework}` - Framework (ej: "spring")
- `${isSpring}` - Boolean: true si es Spring
- `${isQuarkus}` - Boolean: true si es Quarkus

### Variables de Paradigma
- `${paradigm}` - Paradigma (ej: "reactive")
- `${isReactive}` - Boolean: true si es reactivo
- `${isImperative}` - Boolean: true si es imperativo

### Variables de Versiones
- `${javaVersion}` - Versión de Java (ej: "21")
- `${springBootVersion}` - Versión de Spring Boot (ej: "3.3.0")
- `${mapstructVersion}` - Versión de MapStruct (ej: "1.5.5.Final")

## 📚 Pasos para Agregar una Nueva Arquitectura

1. **Crear la carpeta** en `templates/architectures/`
2. **Crear `structure.yml`** con la definición
3. **Crear carpeta `project/`** con los templates raíz
4. **Si es multi-módulo**, crear carpeta `modules/` con templates de cada módulo
5. **Agregar el enum** en `ArchitectureType.java` (en el core)
6. **Probar** generando un proyecto con la nueva arquitectura

## 🚀 Comando para Probar

```bash
./gradlew initCleanArch \
  --architecture=mi-arquitectura-multi \
  --packageName=com.pragma.test
```

## 📝 Notas Adicionales

- Los templates usan **Freemarker** (`.ftl`)
- Los archivos generados mantienen el nombre sin `.ftl`
- `BeanConfiguration.java.ftl` es opcional pero recomendado para Spring
- En multi-módulo, `BeanConfiguration` se genera en el módulo `infrastructure`
- El `settings.gradle.kts.ftl` debe incluir todos los módulos con `include()`

---

**Última actualización:** 2026-02-01  
**Versión:** 1.0
