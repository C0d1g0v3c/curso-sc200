---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# Tamper protection

**Definicion:** Advanced feature de MDE que bloquea cambios a configuraciones criticas de seguridad de Microsoft Defender Antivirus, incluso con privilegios de administrador local o via Registro/PowerShell/GPO.

**Por que existe:** Evita que un atacante que ya comprometio una cuenta admin local apague el antivirus antes de desplegar su payload.

**Como funciona:** Cualquier intento de cambiar configuracion protegida (Registro, PowerShell, GPO, interfaz local) es bloqueado aunque el usuario tenga privilegios administrativos en esa maquina; el cambio solo se puede hacer centralizado desde MDE.

**Donde se configura / rol necesario:** Settings > Endpoints > Advanced features > Tamper protection. Requiere Security Administrator.

**Ejemplo:** Un comando `Set-MpPreference -DisableRealtimeMonitoring $true` ejecutado por un atacante con admin local falla silenciosamente si tamper protection esta activo.

**Trampa de examen:** El escenario "atacante con privilegios admin locales intenta apagar el antivirus" siempre apunta a tamper protection, no a EDR in block mode ni custom network indicators.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
