---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# EDR in block mode

**Definicion:** Advanced feature de MDE que permite bloquear y remediar artefactos maliciosos post-brecha incluso cuando Microsoft Defender Antivirus corre en modo pasivo (porque hay otro antivirus de terceros como proteccion principal).

**Por que existe:** En modo pasivo, Defender Antivirus normalmente no puede bloquear nada. Esta feature agrega una capa de proteccion adicional sin reemplazar el AV de terceros.

**Como funciona:** El motor EDR analiza comportamiento y telemetria (no firmas) y puede terminar procesos y poner en cuarentena artefactos detectados despues de que ya se ejecutaron.

**Donde se configura / rol necesario:** Settings > Endpoints > Advanced features > EDR in block mode. Requiere Security Administrator. El dispositivo debe estar onboardeado a MDE.

**Ejemplo:** Un servidor con AV de terceros sufre un proceso que cifra archivos masivamente (patron ransomware); MDE lo termina via EDR in block mode aunque el AV de terceros no lo detecte.

**Trampa de examen:** No reemplaza al antivirus principal; coexiste con el y actua solo post-brecha.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
