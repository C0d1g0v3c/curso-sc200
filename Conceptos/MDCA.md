---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 10
---
# MDCA (Microsoft Defender for Cloud Apps)

**Definición:** plataforma de Microsoft (CASB, Cloud Access Security Broker) para vigilar y controlar el uso de aplicaciones en la nube — tanto de Microsoft (SharePoint, OneDrive, Exchange Online) como de terceros (Salesforce, Box, Dropbox, Google Workspace).

**Por qué existe:** ni MDE (dispositivos) ni MDO (correo) responden preguntas propias del dato que vive en apps en la nube: qué apps usa realmente la organización (incluido Shadow IT), qué comportamiento anómalo ocurre dentro de ellas, y si se puede controlar en tiempo real lo que un usuario hace dentro de una sesión sin bloquear el acceso completo.

**Cómo funciona:** se conecta a las apps mediante conectores de API (integración directa para analizar actividad histórica y aplicar gobernanza) y mediante Conditional Access App Control (proxy inverso que intercepta tráfico de sesión en tiempo real). Se organiza en cuatro capacidades: Cloud Discovery (descubrir apps usadas, incluido Shadow IT), App governance/OAuth apps (evaluar riesgo de apps de terceros), Information protection (extender etiquetas de Purview a apps de terceros), y Threat protection (anomaly detection policies + session policies).

**Dónde se configura / rol necesario:** portal de Defender, nodo Cloud apps. Requiere licencia de MDCA (standalone o incluida en M365 E5) y, para session/access policies, Microsoft Entra ID P1.

**Ejemplo:** el SOC detecta una app OAuth de terceros descargando cientos de archivos de SharePoint de forma atípica; investiga en App governance y revoca sus permisos.

**Trampa de examen:** distinguir en qué capacidad de MDCA cae cada escenario — Cloud Discovery es descubrimiento, App governance es sobre apps OAuth, anomaly detection es alerta post-hecho, session policy es control en tiempo real dentro de una sesión.

## Lecciones donde aparece
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]]
