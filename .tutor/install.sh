#!/usr/bin/env bash
# Instala el agente sc200-study-tutor en ~/.claude/agents/
# Uso:  bash install.sh          (enlace simbolico, se actualiza con git pull)
#       bash install.sh --copy   (copia, si tu sistema no admite symlinks)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_SRC="$SCRIPT_DIR/sc200-study-tutor.md"
AGENT_DIR="$HOME/.claude/agents"
AGENT_DST="$AGENT_DIR/sc200-study-tutor.md"

# El vault es tres niveles arriba de .tutor/  ->  SC-200 / certs en curso / <vault>
VAULT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
DEFAULT_VAULT="$HOME/ob/assel"

[ -f "$AGENT_SRC" ] || { echo "ERROR: no encuentro $AGENT_SRC" >&2; exit 1; }

mkdir -p "$AGENT_DIR"

# Si ya existe algo distinto de nuestro symlink, respaldarlo antes de tocarlo
if [ -e "$AGENT_DST" ] && [ ! -L "$AGENT_DST" ]; then
  BACKUP="$AGENT_DST.bak-$(date +%Y%m%d%H%M%S)"
  cp "$AGENT_DST" "$BACKUP"
  echo "  Ya habia un agente ahi. Respaldado en:"
  echo "    $BACKUP"
fi

if [ "${1:-}" = "--copy" ]; then
  cp "$AGENT_SRC" "$AGENT_DST"
  echo "OK  Agente copiado en $AGENT_DST"
  echo "    (con --copy tendras que reinstalar tras cada git pull)"
else
  ln -sfn "$AGENT_SRC" "$AGENT_DST"
  echo "OK  Agente enlazado en $AGENT_DST"
  echo "    -> $AGENT_SRC"
  echo "    Los git pull se reflejan solos."
fi

echo
if [ "$VAULT_ROOT" = "$DEFAULT_VAULT" ]; then
  echo "OK  Vault en la ubicacion por defecto: $VAULT_ROOT"
  echo "    No necesitas configurar nada mas."
else
  echo "!!  Tu vault NO esta en la ruta por defecto."
  echo "      detectado: $VAULT_ROOT"
  echo "      esperado:  $DEFAULT_VAULT"
  echo
  echo "    Anade esto a tu ~/.bashrc o ~/.zshrc para que el agente lo encuentre:"
  echo
  echo "      export SC200_VAULT=\"$VAULT_ROOT\""
  echo
fi

# Avisos no bloqueantes
command -v git >/dev/null 2>&1 || echo "!!  git no esta instalado: el agente no podra commitear."
if ! git -C "$VAULT_ROOT/certs en curso/SC-200" rev-parse --git-dir >/dev/null 2>&1; then
  echo "!!  $VAULT_ROOT/certs en curso/SC-200 no es un repo Git."
  echo "    Clona ahi https://github.com/C0d1g0v3c/curso-sc200 antes de usar el agente."
fi

echo
echo "Listo. Abre Claude Code y pide \"que toca hoy\" o \"dame la leccion de hoy\"."
