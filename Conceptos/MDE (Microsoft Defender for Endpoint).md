---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# MDE (Microsoft Defender for Endpoint)

**Definicion:** Plataforma de Microsoft para proteger, detectar y responder a amenazas directamente en endpoints (PCs, laptops, servidores, moviles). Combina Microsoft Defender Antivirus, EDR (Endpoint Detection and Response), ASR rules, gestion de vulnerabilidades y una consola centralizada en security.microsoft.com.

**Por que existe:** El antivirus tradicional por firma no detecta abuso de herramientas legitimas del sistema (PsExec, Mimikatz, PowerShell ofuscado) ni malware polimorfico. MDE combina firma + comportamiento y da visibilidad centralizada de toda la flota de dispositivos.

**Como funciona:** Cada dispositivo se onboardea con un sensor que envia telemetria continua (procesos, archivos, red, registro) al backend en la nube, que correlaciona con inteligencia de amenazas y genera alertas.

**Donde se configura / rol necesario:** Settings > Endpoints en el portal de Defender. Ver requiere Security Reader; modificar requiere Security Administrator.

**Ejemplo:** 5000 dispositivos onboardeados permiten ver desde una sola consola cualquier ejecucion sospechosa de PowerShell o acceso anomalo a LSASS.

**Trampa de examen:** Distinguir "Microsoft Defender Antivirus" (motor de proteccion, puede correr sin MDE) de "MDE" (plataforma completa con EDR y consola centralizada).

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
