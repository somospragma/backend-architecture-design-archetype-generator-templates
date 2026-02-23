# Guía de Symlinks - Templates Repository

## ¿Qué son los Symlinks?

Los **symlinks (enlaces simbólicos)** son atajos del sistema de archivos que apuntan a archivos o directorios en otra ubicación. Son como accesos directos, pero a nivel del sistema operativo.

## Estructura Actual

```
templates/
├── adapters/                   # ⚠️ SYMLINKS (atajos)
│   ├── mongodb -> ../frameworks/spring/reactive/adapters/driven-adapters/mongodb
│   ├── redis -> ../frameworks/spring/reactive/adapters/driven-adapters/redis
│   └── rest -> ../frameworks/spring/reactive/adapters/entry-points/rest
│
└── frameworks/                 # 🎯 ARCHIVOS REALES
    └── spring/
        └── reactive/
            └── adapters/
                ├── driven-adapters/
                │   ├── mongodb/    ← Archivos reales aquí
                │   ├── redis/      ← Archivos reales aquí
                │   └── postgresql/
                └── entry-points/
                    └── rest/       ← Archivos reales aquí
```

## ¿Por qué Usar Symlinks?

1. **Un solo lugar de verdad**: Los templates reales están en `frameworks/`, no duplicados
2. **Retrocompatibilidad**: Código antiguo que busca en `adapters/` sigue funcionando
3. **Acceso rápido**: Puedes usar `adapters/mongodb/` en lugar de la ruta larga
4. **Ahorro de espacio**: No duplicas archivos

## Comandos Básicos

### Verificar Symlinks

```bash
# Ver si es un symlink (la 'l' al inicio indica link)
ls -la templates/adapters/
# Salida:
# lrwxr-xr-x ... mongodb -> ../frameworks/spring/reactive/adapters/driven-adapters/mongodb
# ↑ Esta 'l' indica que es un symlink

# Ver a dónde apunta un symlink específico
readlink templates/adapters/mongodb
# Salida: ../frameworks/spring/reactive/adapters/driven-adapters/mongodb

# Seguir el symlink y ver los archivos reales
ls -la templates/adapters/mongodb/
# Muestra los archivos en la carpeta de destino
```

### Crear Symlinks

```bash
# Sintaxis: ln -s <destino> <nombre_del_link>

# Ejemplo 1: Crear symlink para PostgreSQL
cd templates/adapters/
ln -s ../frameworks/spring/reactive/adapters/driven-adapters/postgresql postgresql

# Ejemplo 2: Crear symlink para GraphQL
cd templates/adapters/
ln -s ../frameworks/spring/reactive/adapters/entry-points/graphql graphql

# Verificar que se creó correctamente
ls -la postgresql
# Debe mostrar: postgresql -> ../frameworks/spring/reactive/adapters/driven-adapters/postgresql
```

### Eliminar Symlinks

```bash
# Eliminar el symlink (NO elimina los archivos de destino)
rm templates/adapters/mongodb

# Los archivos reales permanecen seguros en:
# templates/frameworks/spring/reactive/adapters/driven-adapters/mongodb/
```

## Workflow: Agregar un Nuevo Adaptador

### Paso 1: Crear Templates Reales

```bash
# Crear la carpeta en frameworks/ (NO en adapters/)
mkdir -p templates/frameworks/spring/reactive/adapters/driven-adapters/postgresql

# Navegar a la carpeta
cd templates/frameworks/spring/reactive/adapters/driven-adapters/postgresql

# Crear los archivos de template
touch Adapter.java.ftl
touch Entity.java.ftl
touch Config.java.ftl
touch Repository.java.ftl
touch metadata.yml
touch application-properties.yml.ftl
```

### Paso 2: Desarrollar los Templates

Edita los archivos `.ftl` con el contenido necesario.

### Paso 3: (Opcional) Crear Symlink

```bash
# Navegar a la carpeta de symlinks
cd templates/adapters/

# Crear el symlink
ln -s ../frameworks/spring/reactive/adapters/driven-adapters/postgresql postgresql

# Verificar
ls -la postgresql
readlink postgresql
```

### Paso 4: Probar

```bash
# En el proyecto core, usar modo developer
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
```

## Consideraciones Cross-Platform

### macOS / Linux

```bash
# Crear symlink
ln -s ../frameworks/spring/reactive/adapters/driven-adapters/mongodb mongodb

# Verificar
ls -la mongodb
```

### Windows

**Opción 1: PowerShell (Requiere permisos de administrador)**
```powershell
# Crear symlink
New-Item -ItemType SymbolicLink -Path mongodb -Target ..\frameworks\spring\reactive\adapters\driven-adapters\mongodb

# Verificar
Get-Item mongodb | Select-Object LinkType, Target
```

**Opción 2: CMD (Requiere permisos de administrador)**
```cmd
# Crear symlink de directorio
mklink /D mongodb ..\frameworks\spring\reactive\adapters\driven-adapters\mongodb

# Verificar
dir mongodb
```

**Habilitar Developer Mode en Windows 10/11:**
1. Abrir Configuración → Actualización y seguridad → Para desarrolladores
2. Activar "Modo de desarrollador"
3. Ahora puedes crear symlinks sin permisos de administrador

### Git y Symlinks

**Configuración de Git:**
```bash
# Verificar configuración actual
git config core.symlinks

# Habilitar symlinks (recomendado en Unix)
git config core.symlinks true

# En Windows, Git Bash maneja symlinks automáticamente si está habilitado
```

**Comportamiento:**
- Git almacena symlinks como archivos especiales
- Al clonar, Git recrea los symlinks automáticamente
- En Windows, requiere `core.symlinks=true` o Developer Mode

## Mejores Prácticas

### ✅ HACER

1. **Crear templates reales en `frameworks/`**
   ```bash
   mkdir -p templates/frameworks/spring/reactive/adapters/driven-adapters/nuevo-adaptador
   ```

2. **Usar rutas relativas en symlinks**
   ```bash
   ln -s ../frameworks/spring/reactive/... nombre
   ```

3. **Documentar symlinks en README**
   - Explicar qué son
   - Listar symlinks existentes
   - Explicar cómo crearlos

4. **Verificar symlinks antes de commit**
   ```bash
   ls -la templates/adapters/
   readlink templates/adapters/*
   ```

### ❌ NO HACER

1. **NO crear templates directamente en `adapters/`**
   ```bash
   # ❌ INCORRECTO
   mkdir templates/adapters/nuevo-adaptador
   
   # ✅ CORRECTO
   mkdir templates/frameworks/spring/reactive/adapters/driven-adapters/nuevo-adaptador
   ```

2. **NO usar rutas absolutas**
   ```bash
   # ❌ INCORRECTO (rompe portabilidad)
   ln -s /Users/usuario/templates/frameworks/... nombre
   
   # ✅ CORRECTO
   ln -s ../frameworks/spring/reactive/... nombre
   ```

3. **NO crear symlinks circulares**
   ```bash
   # ❌ INCORRECTO (A → B → A)
   ln -s ../b a
   ln -s ../a b
   ```

4. **NO commitear symlinks rotos**
   ```bash
   # Verificar antes de commit
   find templates/adapters -type l -exec test ! -e {} \; -print
   ```

## Troubleshooting

### Symlink Roto

**Síntoma:**
```bash
ls -la templates/adapters/mongodb
# mongodb -> ../frameworks/spring/reactive/adapters/driven-adapters/mongodb (rojo)
```

**Solución:**
```bash
# Verificar que el destino existe
ls -la templates/frameworks/spring/reactive/adapters/driven-adapters/mongodb

# Si no existe, crear la carpeta
mkdir -p templates/frameworks/spring/reactive/adapters/driven-adapters/mongodb

# O eliminar el symlink roto
rm templates/adapters/mongodb
```

### Symlink No Funciona en Windows

**Síntoma:**
```
You do not have sufficient privilege to perform this operation.
```

**Solución:**
1. Ejecutar PowerShell/CMD como Administrador, O
2. Habilitar Developer Mode en Windows 10/11, O
3. Configurar Git: `git config core.symlinks true`

### Git No Recrea Symlinks al Clonar

**Síntoma:**
Después de clonar, `templates/adapters/mongodb` es un archivo de texto en lugar de un symlink.

**Solución:**
```bash
# Habilitar symlinks en Git
git config core.symlinks true

# Re-clonar el repositorio
rm -rf repositorio
git clone <url>
```

## Ejemplos Completos

### Ejemplo 1: Agregar Adaptador DynamoDB

```bash
# 1. Crear estructura real
mkdir -p templates/frameworks/spring/reactive/adapters/driven-adapters/dynamodb
cd templates/frameworks/spring/reactive/adapters/driven-adapters/dynamodb

# 2. Crear archivos
cat > Adapter.java.ftl << 'EOF'
package ${packageName};

import reactor.core.publisher.Mono;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbAsyncTable;

public class ${adapterName}DynamoDbAdapter {
    private final DynamoDbAsyncTable<${entityName}Entity> table;
    
    public Mono<${entityName}> save(${entityName} entity) {
        // Implementation
    }
}
EOF

cat > metadata.yml << 'EOF'
name: dynamodb
displayName: DynamoDB
description: AWS DynamoDB adapter with SDK v2
framework: spring
paradigm: reactive
type: driven-adapter
version: 1.0.0
EOF

# 3. Crear symlink
cd ../../../../adapters/
ln -s ../frameworks/spring/reactive/adapters/driven-adapters/dynamodb dynamodb

# 4. Verificar
ls -la dynamodb
readlink dynamodb

# 5. Commit
git add templates/frameworks/spring/reactive/adapters/driven-adapters/dynamodb/
git add templates/adapters/dynamodb
git commit -m "Add DynamoDB adapter for Spring Reactive"
```

### Ejemplo 2: Agregar Framework Quarkus

```bash
# 1. Crear estructura para Quarkus Reactive
mkdir -p templates/frameworks/quarkus/reactive/adapters/driven-adapters/mongodb
cd templates/frameworks/quarkus/reactive/adapters/driven-adapters/mongodb

# 2. Crear templates (con Uni/Multi en lugar de Mono/Flux)
# ... crear archivos .ftl ...

# 3. NO crear symlinks en adapters/ todavía
# Los symlinks actuales apuntan a Spring Reactive

# 4. El generador debe resolver basándose en framework + paradigm:
# - framework=spring, paradigm=reactive → frameworks/spring/reactive/...
# - framework=quarkus, paradigm=reactive → frameworks/quarkus/reactive/...
```

## Referencias

- [Documentación oficial de ln](https://man7.org/linux/man-pages/man1/ln.1.html)
- [Git Symlinks](https://git-scm.com/docs/git-config#Documentation/git-config.txt-coresymlinks)
- [Windows Symlinks](https://docs.microsoft.com/en-us/windows/win32/fileio/symbolic-links)

## Preguntas Frecuentes

**P: ¿Debo crear symlinks para todos los adaptadores?**
R: No es obligatorio. Los symlinks son opcionales y sirven para conveniencia. El generador debe buscar en `frameworks/` directamente.

**P: ¿Qué pasa si elimino un symlink?**
R: Solo se elimina el atajo, los archivos reales en `frameworks/` permanecen intactos.

**P: ¿Puedo tener múltiples symlinks apuntando al mismo destino?**
R: Sí, puedes crear varios symlinks que apunten a la misma carpeta.

**P: ¿Los symlinks funcionan en todos los sistemas operativos?**
R: Sí, pero en Windows requieren permisos especiales o Developer Mode habilitado.

**P: ¿Git versiona los symlinks?**
R: Sí, Git almacena symlinks como archivos especiales y los recrea al clonar (si `core.symlinks=true`).
