# CI de templates

Cada cambio en templates se prueba generando proyectos reales con el plugin, compilándolos con sus tests (ArchUnit incluido) y escaneando sus dependencias. Los pipelines van por etapas: **Quality (CI) → Security (CI) → Build → Approval → Deploy (CD)**. Cada job lleva la etapa en su nombre, así que el grafo de GitHub Actions las muestra en columnas.

## Ramas

- `main` es la rama por defecto y la única de integración: todo entra por PR desde `feat/*` o `fix/*`.
- Cada merge a `main` crea el tag siguiente `v<mayor>.x.y`, y el plugin de cada mayor lee el último tag de su mayor. Por eso todo PR a `main` necesita la aprobación del environment `promote`.
- `release/<mayor>.x` solo existe para parchear un mayor viejo.
- El detalle de cómo se publica, cómo se sube el minor, cómo se saca un mayor nuevo y el corte con el plugin 1.0.x está en [publicacion-y-despliegue.md](publicacion-y-despliegue.md).

## Workflows

| Workflow | Cuándo corre | Etapas |
|---|---|---|
| `ci.yml` | PR y push a `main` y `release/**` | Quality: contrato. Security: gitleaks, actionlint y zizmor. Build: cada arquitectura × paradigma generada, compilada, probada y con sus dependencias escaneadas; con `TEST_RELEASED_PLUGIN=true` también con el último plugin publicado. Approval: en cada PR, aprobación del environment `promote`. Deploy: el merge crea el tag `v<mayor>.x.y` |
| `security-weekly.yml` | cada lunes a las 07:00 UTC | Build: genera un proyecto por arquitectura × paradigma con todos los adapters. Security, sobre cada uno: dependencias (OSV), código (CodeQL `security-extended`) y secretos (gitleaks). OSV publica en la pestaña Security. Report: abre o actualiza un issue `security-weekly`; una corrida limpia lo cierra |
| `nightly.yml` | cada día a las 06:00 UTC | cada adapter solo en su propio proyecto, y violaciones metidas a propósito que el build debe rechazar |
| `generation.yml` | lo llaman los anteriores | la matriz de generación |

La matriz sale de `architectures/index.yml` y de los `index.json` de adapters. Una arquitectura o un adapter nuevo entra a la matriz, y al escaneo semanal, sin tocar los workflows.

| Modo | Proyectos | Qué prueba |
|---|---|---|
| `full` | cada arquitectura × paradigma | entidad, caso de uso y todos los adapters en el mismo proyecto; `build` con tests |
| `isolated` | `hexagonal-single` × paradigma × adapter | que cada adapter compile y pase sus tests solo |
| `negative` | cada arquitectura × paradigma | que se rechacen un dominio con Spring, un caso de uso que usa un adapter y, en reactivo, un `block()` |

## Seguridad de lo generado

Lo que reciben los usuarios son los proyectos generados, así que se escanean como ellos los recibirían:

| Escaneo | Herramienta | Bloquea | Cuándo |
|---|---|---|---|
| Dependencias, árbol completo | OSV-Scanner sobre los lockfiles que escribe Gradle | CVSS ≥ `quality.owasp-fail-on-cvss` de `versions.yml` (hoy 7.0) | cada PR y cada lunes |
| Código | CodeQL `security-extended` | security-severity ≥ 7.0 | cada lunes |
| Secretos | gitleaks sobre el proyecto | cualquier hallazgo | cada lunes |

Los hallazgos de OSV se publican en la pestaña Security (code scanning, una categoría `osv/<arquitectura>-<paradigma>` por proyecto). Como los lockfiles viven en el proyecto generado y no en este repositorio, cada alerta muestra el paquete y el aviso, pero no una línea de código. Los de CodeQL quedan en el resumen del run y como SARIF en sus artefactos, porque apuntan a código que no existe en el repositorio.

Si el escaneo semanal corre sin `TEST_RELEASED_PLUGIN`, revisa `main` con el plugin de core `main`. Con la variable activa, revisa el último tag `v<mayor>.x.y` con el plugin publicado, que es lo que usa la gente.

Para corregir una dependencia vulnerable basta subir su versión en `versions.yml`: llega a los usuarios sin publicar plugin. Si la versión vulnerable llega como transitiva de otra librería, se fuerza desde el `buildConfiguration` del adapter que la trae, con `resolutionStrategy` (como en grpc, redis y postgresql reactivo). Nunca con un bloque `dependencies { }`: el plugin metería ahí las dependencias del siguiente adapter.

## Scripts

Se corren igual en local:

```bash
# El plugin tiene que estar en mavenLocal: ./gradlew publishToMavenLocal en el core
scripts/ci/check-contract.py templates
scripts/ci/generate-and-build.sh --architecture onion-single --paradigm reactive \
  --plugin-version 1.3.5-SNAPSHOT --templates templates --out build/generated
scripts/ci/negative-check.sh --project build/generated/onion-single-reactive --paradigm reactive
scripts/ci/scan-dependencies.sh --project build/generated/onion-single-reactive   # necesita osv-scanner
scripts/ci/sarif-gate.sh --sarif resultados.sarif --fail-on-severity 7.0
```

El CI del core usa `generate-and-build.sh` para su prueba de humo, y `scan-dependencies.sh` e `install-tools.sh` para escanear el plugin.

## Configuración en GitHub (una sola vez)

**Ruleset de `main` y `release/**`**
- PR obligatorio, sin aprobaciones de código: la aprobación humana es la del environment `promote`.
- Check obligatorio: `ci-ok`. En un PR a `main`, `ci-ok` espera al job Approval, así que no se puede mergear sin la aprobación del environment.
- Sin force push ni borrado.

**Ruleset de tags `v*`**
- Activar "Restrict updates" y "Restrict deletions": nadie puede mover ni borrar un tag publicado.
- No restringir la creación, o el job Deploy no podría crear el tag con el `GITHUB_TOKEN`.

**Environment `promote`**
- Revisor obligatorio: dayepesb-pragma. Sin "Prevent self-review", para que el revisor pueda aprobar sus propios PR.
- Deployment branches: sin restricción. Corre sobre el PR de promoción, cuya ref es la del PR; la protección real es el revisor.
- No guarda secretos: solo es la aprobación.

**Variables del repositorio**
- `TEST_RELEASED_PLUGIN=true` cuando ya esté publicado el primer plugin que lee tags de templates. Antes de eso, el plugin publicado (1.0.5) no entiende `schemaVersion` y esa matriz fallaría.
- `PLUGIN_MAJOR`: mayor que publica `main` (por defecto `1`); se sube a `2` junto con un cambio incompatible.
- `CORE_REF`: solo mientras un cambio toca los dos repos a la vez. El CI construye el plugin desde esa rama del core en vez de `main`. Se borra al mergear.

**Seguridad del repositorio**
- Dependabot alerts y Dependabot security updates (activas desde el 2026-11-10).
- Secret scanning con push protection.
- Actions: permisos del `GITHUB_TOKEN` en solo lectura. El job que crea el tag pide `contents: write`, el escaneo semanal `security-events: write` para publicar en la pestaña Security y su reporte `issues: write`, solo para eso.
