---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 12
---
# CSPM vs CWPP

**Definición:** dentro de [[Defender for Cloud]] (una plataforma CNAPP), **CSPM** (Cloud Security Posture Management) revisa y mejora la configuración de seguridad de los recursos en la nube — responde "¿está bien configurado esto?" antes de que alguien lo explote. **CWPP** (Cloud Workload Protection Platform) defiende workloads que ya están corriendo (VMs, contenedores, storage, bases de datos, funciones serverless) contra amenazas activas — responde "¿alguien está atacando esto ahora mismo?". Existe también una tercera pata, **DevSecOps** (Development Security Operations), que gestiona seguridad a nivel de código en pipelines de CI/CD, antes de que el código se despliegue.

**Por qué existe la distinción:** son dos preguntas distintas con dos respuestas distintas. La postura (CSPM) previene; la protección de workloads (CWPP) detecta y responde. El examen las trata como conceptos separados porque el objetivo del examen de este día ("Investigate and remediate alerts and incidents identified by Microsoft Defender for Cloud workload protections") apunta específicamente a CWPP, no a CSPM.

**Cómo funciona:** CSPM se apoya en **Foundational CSPM** (gratis: políticas centralizadas, [[Secure Score]], cobertura multicloud) y **Defender CSPM** (de pago: attack path analysis, Cloud Security Explorer, escaneo agentless). CWPP se apoya en planes específicos por tipo de recurso: [[Defender for Servers Plan 1 vs Plan 2|Defender for Servers]], Defender for Containers, Defender for Storage, Defender for Databases, Defender for Key Vault, Defender for App Service, Defender for Resource Manager, Defender for APIs.

**Dónde se configura / rol necesario:** ambos viven en el mismo portal (Defender for Cloud → Environment settings), pero se habilitan como planes independientes por suscripción; requiere rol Owner o Contributor sobre la suscripción para habilitarlos.

**Ejemplo:** "Contoso quiere saber si sus VMs tienen puertos innecesarios abiertos" → CSPM (recomendación de configuración). "Contoso detecta ejecución de Mimikatz en una VM" → CWPP (alerta de amenaza activa, requiere Defender for Servers habilitado).

**Trampa de examen:** Foundational CSPM (gratis) YA incluye Secure Score y recomendaciones — el distractor "necesitas pagar para tener Secure Score" es falso. Lo que sí es de pago es el análisis avanzado (attack path, Cloud Security Explorer) y el escaneo sin agente.

## Lecciones donde aparece
- [[Dia 12 - Defender for Cloud Workload Protections]]
