---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 12
---
# Defender for Servers: Plan 1 vs Plan 2

**Definición:** el plan CWPP de [[Defender for Cloud]] que protege máquinas virtuales Windows y Linux, en Azure, AWS, GCP y on-premises. Existe en dos niveles: **Plan 1**, que da la protección base (onboarding automático de Microsoft Defender for Endpoint / MDE, alertas integradas a Defender XDR, escaneo de vulnerabilidades con agente), y **Plan 2**, que añade toda la capa proactiva: escaneo agentless de vulnerabilidades/malware/secretos, File Integrity Monitoring, [[JIT VM access]], detección de amenazas de red, y las alertas de Defender for DNS.

**Por qué existe la distinción de dos planes:** permite a una organización elegir entre protección básica de bajo costo (Plan 1) y protección avanzada con capacidades de postura activa (Plan 2), sin forzar a todos a pagar por capacidades que no necesitan en todas sus VMs.

**Cómo funciona:** ambos planes hacen onboarding automático del sensor EDR (Endpoint Detection and Response) de MDE en la máquina. Defender for Servers ya no depende del agente clásico de Log Analytics ni de Azure Monitor Agent (AMA) para sus funciones de protección — el escaneo agentless y la integración con MDE reemplazaron esa dependencia; AMA solo sigue siendo relevante para aprovechar 500 MB de ingesta gratuita a Log Analytics (exclusivo de Plan 2).

**Dónde se configura / rol necesario:** `portal.azure.com` → Defender for Cloud → Environment settings → seleccionar la suscripción → Defender for Servers → elegir Plan 1 o Plan 2. Requiere rol Owner o Contributor sobre la suscripción.

**Ejemplo:** Contoso habilita Plan 2 sobre sus VMs de producción para tener JIT VM access y FIM; sobre VMs de desarrollo de bajo riesgo, deja Plan 1 para ahorrar costo, sabiendo que renuncia a escaneo agentless y JIT ahí.

**Trampa de examen:** [[JIT VM access]] y **File Integrity Monitoring** solo existen en Plan 2 — si el enunciado pide esas capacidades y no aclara el plan, la respuesta correcta implica Plan 2, no Plan 1. JIT tampoco cubre GCP, solo Azure y AWS.

## Lecciones donde aparece
- [[Dia 12 - Defender for Cloud Workload Protections]]
