# Agente tutor SC-200

Definición del subagente `sc200-study-tutor` de Claude Code, versionada junto a los apuntes
para que se comporte igual en cualquier máquina.

Esta carpeta empieza con punto: **Obsidian la ignora**, así que estos archivos no aparecen
como notas en el vault, pero sí van en el repo.

## Instalación

### Linux / macOS

```bash
cd ~/ob/assel/certs\ en\ curso/SC-200/.tutor
bash install.sh
```

Crea un enlace simbólico en `~/.claude/agents/`, así que cada `git pull` actualiza el agente
sin reinstalar. Si tu sistema de archivos no admite symlinks, usa `bash install.sh --copy`.

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\ob\assel\certs en curso\SC-200\.tutor\install.ps1"
```

En Windows se copia el archivo (los symlinks piden privilegios de administrador), así que hay
que volver a correr el script después de cada `git pull`.

Ambos scripts respaldan cualquier versión previa del agente antes de sobrescribirla.

## Si el vault no está en `~/ob/assel`

El agente resuelve las rutas así:

```bash
VAULT="${SC200_VAULT:-$HOME/ob/assel}"
REPO="$VAULT/certs en curso/SC-200"
```

`$HOME` funciona igual en Git Bash (`/c/Users/<user>`) y en Linux (`/home/<user>`), así que
mientras el vault esté en `~/ob/assel` no hay nada que configurar. Si lo tienes en otro sitio,
el instalador lo detecta y te imprime la línea exacta a añadir en tu `~/.bashrc`:

```bash
export SC200_VAULT="/ruta/a/tu/vault"
```

## Requisitos

| Requisito | Para qué |
|---|---|
| Claude Code | Ejecutar el agente |
| `git` con credenciales de GitHub | El agente commitea y sube al cerrar cada lección |
| El repo clonado en `<vault>/certs en curso/SC-200` | Es su fuente de calendario y tracker |

No requiere ningún servidor MCP. La versión anterior dependía de las tools `mcp__obsidian__*`;
ahora usa `Read`/`Write`/`Glob`, que funcionan en cualquier instalación.

## Cómo se usa

Basta con pedirlo en lenguaje natural — el agente se lanza solo:

- «qué toca hoy»
- «dame la lección de hoy»
- «hazme el quiz del día 5»
- «explícame attack disruption con ejemplos y un video»

## Qué escribe el agente

| Ruta | Qué |
|---|---|
| `<repo>/Lecciones Diarias/Dia NN - <Tema>.md` | La lección, con frontmatter para el dashboard |
| `<repo>/TRACKER_TUTOR.md` | Una línea de progreso por sesión |
| `<vault>/tasks.md` | Misiones del día, **sin marcar** (fuera del repo) |

No toca ninguna otra nota sin permiso explícito, y nunca marca casillas ni edita `history.md`:
los puntos del plugin Gamified Task Manager se otorgan al marcarlas desde el propio plugin.

## Mantenimiento

El agente lleva dentro estado que caduca y hay que revisar:

- **El calendario.** No calcula el día restando fechas — lee la tabla «CALENDARIO VIGENTE» de
  `GUIA_INTENSIVA_24_DIAS.md`. Si reanclas el plan, actualiza esa tabla y el agente se adapta solo.
- **Fechas del examen** (sección «Fechas del proyecto»).
- **La lista de errores conocidos del corpus legacy** (sección «Estado conocido del corpus»),
  que hay que podar según se vayan corrigiendo las notas.
- **El temario**, si Microsoft vuelve a actualizar el outline.
