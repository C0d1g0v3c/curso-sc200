---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 6
---
# Automation rules

**Definicion:** Mecanismo central de Sentinel/Defender para gestionar automatizacion: un conjunto de reglas transversales que se aplican a incidentes y alertas sin repetir logica en cada analytics rule.

**Por que existe:** Sin ellas, cada analytics rule tendria que llevar su propia logica de respuesta, duplicando configuracion. Centralizan trigger + condiciones + acciones en un solo lugar.

**Como funciona:** Tres piezas: Trigger (incident created, incident updated, alert created), Conditions (estado actual o cambios de estado de propiedades), Actions (cambiar estado/severidad/owner/tag, agregar tarea, o Run playbook). Cada tipo de trigger mantiene su propia cola de orden; las reglas de "incident created" corren completas antes que las de "incident updated"; dentro de la misma cola corren secuencialmente (nunca en paralelo) y cada regla evalua el estado YA modificado por las anteriores. Admite fecha de expiracion.

**Donde se configura / rol necesario:** Automation > Create > Automation rule (en Sentinel o portal de Defender), tambien desde el wizard de una analytics rule o desde la pagina de un incidente. Requiere Microsoft Sentinel Contributor sobre el workspace.

**Ejemplo:** Una regla que baja la severidad de "Suspicious PowerShell activity" de High a Low antes de que otra regla (que solo actua sobre High/Critical) evalue ese mismo incidente.

**Trampa de examen:** Cuando dos reglas del mismo trigger se encadenan, la segunda evalua el estado modificado por la primera, no el estado original del incidente.

## Lecciones donde aparece
- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]
