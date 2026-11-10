# Publicación y despliegue de templates

Las plantillas se publican con tags. Cada tag `v<mayor>.x.y` es una versión que reciben los usuarios, y el plugin de cada mayor lee el último tag de su mayor. Por ejemplo, el plugin 1.x lee el `v1.x.y` más alto.

## Ramas y tags

| Rama o tag | Para qué |
|---|---|
| `develop` | integración y rama por defecto. Los PR desde `feat/*` o `fix/*` entran aquí con `ci-ok` en verde |
| `main` | lo publicado. Solo recibe PR desde `develop` (o un hotfix), con aprobación |
| `v<mayor>.<minor>.<patch>` (tag) | una versión publicada. La crea el CI al mergear a `main` |
| `release/<mayor>.x` | solo para parchear un mayor viejo cuando `main` ya va en el siguiente |

```
feat/* ──PR──▶ develop ──PR + aprobación──▶ main ──CI──▶ tag v1.4.3 ──▶ plugin 1.x lo lee
```

## Publicar una versión

1. Abrir un PR de `develop` a `main`. El CI rechaza un PR a `main` que no venga de `develop`.
2. El PR corre por etapas:
   - **Quality (CI):** contrato de las plantillas.
   - **Security (CI):** gitleaks y lint de los workflows.
   - **Build:** genera, compila, prueba y escanea con OSV las 8 combinaciones de arquitectura × paradigma con el plugin de core `main`. Con `TEST_RELEASED_PLUGIN=true`, también con el último plugin publicado.
   - **Approval:** un revisor del environment `promote` aprueba. Hasta entonces `ci-ok` queda pendiente y el PR no se puede mergear.
3. Al mergear, **Deploy (CD)** crea el tag siguiente: si el último era `v1.4.2`, crea `v1.4.3`.
4. Desde ese momento, todo usuario del plugin 1.x genera con `v1.4.3`, sin actualizar el plugin.

**Subir el minor** (una arquitectura o un adapter nuevo, por ejemplo): crear el tag a mano sobre el merge, en vez de dejar el patch automático:

```bash
git tag v1.5.0 <commit-del-merge> && git push origin v1.5.0
```

**Volver atrás:** un tag no se mueve ni se borra. Se revierte en `develop` y se publica un tag nuevo. Mientras tanto, quien no pueda esperar fija el tag anterior en `.cleanarch.yml`:

```yaml
templates:
  version: v1.4.2
```

## Cambio incompatible (nuevo mayor)

Un cambio que el plugin publicado no entiende sube el `schemaVersion` de `architectures/index.yml`:

1. Antes de mergear el cambio a `main`, crear `release/1.x` desde el último tag `v1`, para poder seguir parcheando 1.x.
2. Mergear el cambio a `develop` y luego a `main`, y cambiar la variable `PLUGIN_MAJOR` a `2`. El siguiente tag es `v2.0.0`.
3. Publicar el plugin 2.0.0: su release verifica que existe `v2.x.y` con el schema que lee.
4. Los usuarios de 1.x siguen leyendo `v1.x.y`. Los parches de 1.x entran por PR a `release/1.x`, con la misma aprobación, y el CI los tagea como `v1.x.y`.

## Corte con el plugin 1.0.x

El plugin 1.0.5, ya publicado, lee la rama `main` de templates, no tags, y no entiende `schemaVersion`. Cuando el rescate llegue a `main`, a esos usuarios se les rompe la generación. Por eso el orden es:

1. Mergear el rescate a `develop`.
2. PR de `develop` a `main`, con aprobación. El CI crea `v1.0.0`.
3. Publicar enseguida el plugin nuevo (tag del core), que lee `v1.0.0`.
4. Avisar a los usuarios de 1.0.x que actualicen el plugin.

## Configuración en GitHub

Está en [ci.md](ci.md): la rama por defecto `develop`, los rulesets de `develop` y `main`, el environment `promote` y las variables `TEST_RELEASED_PLUGIN` y `PLUGIN_MAJOR`.
