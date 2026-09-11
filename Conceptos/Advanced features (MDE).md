---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# Advanced features (MDE)

**Definicion:** Interruptores de configuracion a nivel de tenant en Microsoft Defender for Endpoint que activan o desactivan capacidades completas del producto (no reglas de comportamiento como ASR).

**Por que existe:** Muchas capacidades tienen costo de rendimiento, dependen de licencias u otros productos, o cambian el comportamiento de remediacion, por lo que cada tenant las activa segun su arquitectura.

**Como funciona:** Incluye, entre otras, EDR in block mode, tamper protection, live response (con sus 3 interruptores), custom network indicators, web content filtering, configure automatic attack disruption, device discovery. El interruptor "Automated Investigation" fue retirado de la lista tras el retiro de AIR el 1-sep-2026.

**Donde se configura / rol necesario:** Settings > Endpoints > Advanced features en el portal de Defender. Requiere Security Administrator.

**Ejemplo:** Activar EDR in block mode cuando el AV principal es de un tercero, para que MDE pueda bloquear post-brecha.

**Trampa de examen:** El examen exige saber cual advanced feature especifica resuelve cada escenario (no confundir tamper protection con EDR in block mode, por ejemplo).

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
