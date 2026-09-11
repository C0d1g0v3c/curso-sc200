---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# ASR rules (Attack Surface Reduction rules)

**Definicion:** Configuraciones de Microsoft Defender Antivirus que bloquean o auditan comportamientos de software comunmente explotados por atacantes, aunque el archivo no sea malware conocido. 17 reglas totales: 3 "Standard protection rules" y 14 "Other ASR rules".

**Por que existe:** Reduce la superficie de ataque cerrando caminos tipicos del malware (macros de Office, scripts, robo de credenciales de LSASS) antes de que exista firma especifica.

**Como funciona:** Cada regla tiene 4 estados: Not configured/Off (0), Audit (2, registra sin bloquear), Warn (6, bloquea con opcion de desbloqueo del usuario), Block (1, bloqueo total). Dos reglas (LSASS credential theft y Office code injection) no soportan Warn. Despliegue recomendado: Audit 2-4 semanas, revisar impacto en DeviceEvents, luego Block gradual.

**Donde se configura / rol necesario:** Se despliegan via Intune, Configuration Manager, MDM/Policy CSP o Group Policy. En el portal de Defender: Settings > Endpoints > Attack surface reduction rules. Requiere Security Administrator.

**Ejemplo:** Auditar `DeviceEvents` filtrando `ActionType` que empiece con "Asr" para medir impacto antes de mover a Block.

**Trampa de examen:** Preguntan si se puede aplicar Warn a la regla de LSASS (no se puede) y el orden correcto de despliegue (Audit siempre primero).

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
