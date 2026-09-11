---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 12
---
# Secure Score

**Definición:** número único que resume la postura de seguridad general de un entorno dentro de [[Defender for Cloud]], calculado a partir de cuántas recomendaciones de seguridad activas se han remediado frente al total de recomendaciones aplicables.

**Por qué existe:** dar decenas o cientos de recomendaciones sueltas a un equipo de seguridad no ayuda a priorizar. Secure Score traduce todo eso en un solo indicador que sube conforme se remedian recomendaciones, permitiendo comparar la postura a lo largo del tiempo o entre suscripciones, y justificar inversión en seguridad con una métrica entendible por dirección.

**Cómo funciona:** cada recomendación de seguridad pertenece a un "control de seguridad" (grupo de recomendaciones relacionadas), y cada control tiene un peso distinto dentro del score total según su impacto. Remediar una recomendación de un control de alto peso mueve más el número que una de bajo peso. Es parte de **Foundational CSPM**, por lo que está disponible sin costo adicional.

**Dónde se configura / rol necesario:** `portal.azure.com` → Microsoft Defender for Cloud → **Secure Score** (panel general) o dentro de cada recomendación individual. Solo lectura para la mayoría de roles; remediar recomendaciones requiere permisos de Contributor sobre el recurso afectado.

**Ejemplo:** Contoso tiene Secure Score de 62%; identifica que cifrar sus discos gestionados y habilitar MFA para cuentas con permisos de propietario son las dos recomendaciones de mayor peso pendientes, y las prioriza para subir el score antes de una auditoría.

**Trampa de examen:** Secure Score NO requiere ningún plan de pago — es gratis con Foundational CSPM. No confundirlo con **Attack path analysis** o **Cloud Security Explorer**, que sí son de pago (Defender CSPM) y son análisis más avanzados que van más allá de un número agregado.

## Lecciones donde aparece
- [[Dia 12 - Defender for Cloud Workload Protections]]
