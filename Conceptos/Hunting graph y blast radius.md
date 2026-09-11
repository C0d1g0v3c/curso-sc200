---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 15
---
# Hunting graph y blast radius

**Definición:** el **hunting graph** es la experiencia de visualización de relaciones (nodos y aristas) dentro de la página de Advanced Hunting de Microsoft Defender XDR. El **blast radius** es el análisis de "radio de impacto" dentro del **Incident graph** (en la página de un incidente concreto), que evalúa qué activos críticos podría alcanzar un atacante desde el punto ya comprometido. Ambos corren sobre el mismo motor subyacente: **Microsoft Sentinel graph**.

**Por qué existe:** preguntas sobre relaciones ("¿qué puede alcanzar esta cuenta si se compromete?", "¿hay una ruta hacia Domain Admins?") son lentas y propensas a error si se responden con KQL tabular (múltiples `join` encadenados). El grafo las responde visualmente, incluidas rutas indirectas de varios saltos.

**Cómo funciona:** Sentinel graph representa entidades como **nodos** y relaciones como **aristas**, y alimenta cuatro experiencias: hunting graph (exploración libre en Advanced Hunting, con 20 escenarios predefinidos como "Paths to domain admins" o "Access to key vaults"), incident graph con blast radius (dentro de un incidente activo), data risk graphs de Purview (Insider Risk Management / Data Security Investigations), y custom graphs en preview (modelas tus propias relaciones con datos del Sentinel data lake + terceros, vía GQL desde un notebook de VS Code).

**Dónde se configura / rol necesario:** requiere el **Microsoft Sentinel data lake habilitado** + acceso de **al menos solo lectura a Microsoft Security Exposure Management (MSEM)**. Si el data lake ya está activo, el hunting graph y el blast radius se aprovisionan automáticamente al iniciar sesión en Defender — sin activación aparte. Ruta: Investigation & response → Hunting → Advanced hunting → ícono de hunting graph.

**Ejemplo:** investigar si una cuenta de servicio comprometida tiene una ruta de acceso hacia un Azure Key Vault de producción usando el escenario predefinido **Access to key vaults**, en vez de encadenar múltiples `join` en KQL entre tablas de identidad y permisos.

**Trampa de examen:** el hunting graph vive en Advanced Hunting (exploración general); el blast radius vive específicamente en la página de un incidente activo. No son la misma pantalla ni responden exactamente la misma pregunta, aunque comparten motor (Sentinel graph).

## Lecciones donde aparece
- [[Dia 15 - Repaso KQL Advanced Hunting Custom Detections y Hunting Graph]]
