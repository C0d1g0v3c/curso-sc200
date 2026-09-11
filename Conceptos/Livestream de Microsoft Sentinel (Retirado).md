---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# Livestream de Microsoft Sentinel (Retirado)

## Definición

**Livestream** era una función de Microsoft Sentinel que permitía monitorear una hunting query en **near-real-time** (casi en tiempo real): en vez de correr la query una vez, la re-evaluaba continuamente y notificaba al analista cuando aparecían resultados nuevos, sin crear un incidente automáticamente. **Fue retirada a mediados de marzo de 2026** y ya no está disponible en ningún portal.

## Por qué existió (contexto histórico)

Antes de que existieran alternativas más robustas (analytics rules NRT, KQL jobs), Livestream cubría el hueco entre "correr una query manualmente cada vez" y "convertirla en una regla de alerta completa" — daba un monitoreo continuo ligero sin todo el aparato de una analytics rule.

## Cómo funciona (ya no aplica — solo para reconocer la trampa)

No requiere ninguna acción de configuración hoy, porque no existe. Verificado en Microsoft Learn (`hunting`, actualizado 8-ago-2026): *"Microsoft Sentinel livestreams are no longer available."*

## Dónde se configura / rol necesario

No aplica — retirado. La alternativa oficial recomendada por Microsoft: **analytics rules** (incluidas las NRT — Near Real-Time), **KQL jobs** (dentro del Sentinel data lake) o **playbooks**, según si el objetivo acepta o no generar una alerta automática.

## Ejemplo

Un enunciado de práctica escrito con vocabulario de una guía vieja pide "configurar Livestream sobre una hunting query para recibir notificación sin generar un incidente". La traducción correcta hoy: si se acepta generar una alerta automática, usar una NRT analytics rule; si el objetivo es monitoreo puramente manual sin ninguna alerta, revisar periódicamente la columna Results delta de la pestaña Queries.

## Trampa de examen

Cualquier enunciado que mencione "Livestream" como opción vigente está usando terminología retirada — la respuesta correcta nunca es "configurar Livestream", siempre es su alternativa moderna según el matiz exacto del enunciado (alerta automática vs. revisión manual).

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
