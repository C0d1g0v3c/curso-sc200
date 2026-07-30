# Instala el agente sc200-study-tutor en ~\.claude\agents\  (Windows)
# Uso:  powershell -ExecutionPolicy Bypass -File install.ps1
# En Windows se copia el archivo: los symlinks requieren privilegios de administrador.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AgentSrc  = Join-Path $ScriptDir "sc200-study-tutor.md"
$AgentDir  = Join-Path $HOME ".claude\agents"
$AgentDst  = Join-Path $AgentDir "sc200-study-tutor.md"

# El vault es tres niveles arriba de .tutor\
$VaultRoot    = (Resolve-Path (Join-Path $ScriptDir "..\..\..")).Path
$DefaultVault = Join-Path $HOME "ob\assel"

if (-not (Test-Path $AgentSrc)) {
    Write-Error "No encuentro $AgentSrc"
}

if (-not (Test-Path $AgentDir)) {
    New-Item -ItemType Directory -Path $AgentDir -Force | Out-Null
}

# Respaldar cualquier version previa antes de sobrescribir
if (Test-Path $AgentDst) {
    $stamp  = Get-Date -Format "yyyyMMddHHmmss"
    $backup = "$AgentDst.bak-$stamp"
    Copy-Item $AgentDst $backup
    Write-Host "  Ya habia un agente ahi. Respaldado en:"
    Write-Host "    $backup"
}

Copy-Item $AgentSrc $AgentDst -Force
Write-Host "OK  Agente instalado en $AgentDst"
Write-Host "    En Windows es una copia: vuelve a correr este script tras cada git pull."
Write-Host ""

if ($VaultRoot -eq $DefaultVault) {
    Write-Host "OK  Vault en la ubicacion por defecto: $VaultRoot"
    Write-Host "    No necesitas configurar nada mas."
} else {
    Write-Host "!!  Tu vault NO esta en la ruta por defecto."
    Write-Host "      detectado: $VaultRoot"
    Write-Host "      esperado:  $DefaultVault"
    Write-Host ""
    Write-Host "    Define la variable de entorno para que el agente lo encuentre:"
    Write-Host ""
    # El agente lee la ruta desde Git Bash, asi que la quiere en formato POSIX
    $posix = "/" + $VaultRoot.Substring(0,1).ToLower() + $VaultRoot.Substring(2).Replace("\","/")
    Write-Host "      setx SC200_VAULT `"$posix`""
    Write-Host ""
}

$repo = Join-Path $VaultRoot "certs en curso\SC-200"
if (-not (Test-Path (Join-Path $repo ".git"))) {
    Write-Host "!!  $repo no es un repo Git."
    Write-Host "    Clona ahi https://github.com/C0d1g0v3c/curso-sc200 antes de usar el agente."
    Write-Host ""
}

Write-Host "Listo. Abre Claude Code y pide `"que toca hoy`" o `"dame la leccion de hoy`"."
