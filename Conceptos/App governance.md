---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 10
---
# App governance

**Definición:** capacidad de MDCA (Microsoft Defender for Cloud Apps) que evalúa el riesgo de aplicaciones OAuth registradas en Microsoft Entra ID, Google y Salesforce — apps de terceros a las que un usuario dio permiso para acceder a sus datos (correo, archivos, calendario) mediante el protocolo OAuth, sin compartir su contraseña.

**Por qué existe:** las apps OAuth son un vector de ataque creciente: un atacante puede registrar una app maliciosa y pedir permisos amplios a los usuarios sin robar ninguna contraseña. Sin visibilidad centralizada, nadie en el SOC sabe cuántas apps de terceros tienen acceso a los datos de la organización.

**Cómo funciona:** muestra un panel único con todas las apps de terceros con acceso, sus permisos, número de usuarios y nivel de actividad; permite crear políticas proactivas o reactivas que disparen alertas o remediación automática (por ejemplo, revocar permisos de una app sospechosa para toda la organización desde un solo lugar). Las alertas de app governance aparecen en la lista de alertas de Defender XDR con Detection source = "App Governance".

**Dónde se configura / rol necesario:** Cloud apps → App governance, en el portal de Defender.

**Ejemplo:** una anomaly detection policy detecta que una app OAuth descargó 300 archivos de SharePoint en 10 minutos; el analista revisa sus permisos en App governance y los revoca para toda la organización.

**Trampa de examen:** App governance gestiona APLICACIONES con permisos delegados, no sesiones de navegador de usuarios humanos — eso es session policy.

## Lecciones donde aparece
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]]
