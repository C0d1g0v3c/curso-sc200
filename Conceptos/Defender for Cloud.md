---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 12
---
# Microsoft Defender for Cloud

**Definición:** plataforma **CNAPP** (Cloud Native Application Protection Platform) de Microsoft: una sola solución que combina varias herramientas de seguridad para proteger aplicaciones a lo largo de todo su ciclo de vida, desde el código hasta el recurso ya corriendo en producción. No protege un buzón, una identidad ni un endpoint — protege **recursos de infraestructura en la nube**: máquinas virtuales, contenedores, cuentas de almacenamiento, bases de datos, Key Vaults, APIs.

**Por qué existe:** en la nube, la superficie de ataque no son solo identidades y dispositivos, también son recursos de infraestructura mal configurados (un puerto RDP abierto a internet, un contenedor sin parches, una cuenta de Storage pública). Defender for Cloud junta en un solo lugar la mitad de "encontrar la debilidad antes del ataque" ([[CSPM vs CWPP|CSPM]]) y la mitad de "detectar el ataque ya en curso" ([[CSPM vs CWPP|CWPP]]).

**Cómo funciona:** una vez habilitado sobre una suscripción de Azure (y opcionalmente conectado a AWS/GCP), recolecta datos de configuración y de amenazas, calcula un [[Secure Score]], genera recomendaciones, y — cuando se habilitan planes de pago (CWPP) — genera **alertas de seguridad** ante actividad maliciosa activa. Las alertas se correlacionan en **security incidents** (colecciones de alertas relacionadas) usando IA y el MITRE ATT&CK Matrix. Todo esto se integra de forma nativa al portal unificado de Defender XDR, y desde ahí a Microsoft Sentinel (tablas `SecurityAlert` y `SecurityIncident`).

**Dónde se configura / rol necesario:** `portal.azure.com` → **Microsoft Defender for Cloud** → Environment settings (habilitar planes) y Workload protections (dashboard de planes y alertas). Ver alertas en el portal de Defender XDR requiere el rol correcto de RBAC unificado para Defender for Cloud, o ser Global Administrator / Security Administrator en Entra ID.

**Ejemplo:** Contoso conecta su suscripción de Azure, habilita Foundational CSPM (gratis) y ve su Secure Score; luego habilita Defender for Servers Plan 2 sobre sus VMs de producción para recibir alertas de amenaza activa, no solo recomendaciones.

**Trampa de examen:** el esquema de `SecurityAlert` en Sentinel conserva el valor legado `ProductName == "Azure Security Center"`, el nombre comercial anterior del producto — nunca "Microsoft Defender for Cloud" en ese filtro KQL. Está marcado con ⚠️ trampa histórica documentada de este curso.

## Lecciones donde aparece
- [[Dia 12 - Defender for Cloud Workload Protections]]
