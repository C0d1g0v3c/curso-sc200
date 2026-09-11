---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# Hunting Query de Sentinel

## Definición

Una **hunting query** (query de caza de amenazas) es una consulta en **KQL** (Kusto Query Language, el lenguaje de consulta usado en toda la plataforma Sentinel/Defender) que se ejecuta con propósito **proactivo**: buscar patrones sospechosos que ninguna analytics rule (regla automatizada) detecta todavía, en vez de reaccionar a una alerta ya disparada. No hay diferencia de sintaxis con cualquier otra query KQL — la diferencia está en el propósito y en el flujo de trabajo que la rodea (Content Hub, favoritos, MITRE tagging, Results delta).

## Por qué existe

Un SOC (Security Operations Center) que solo reacciona a alertas automáticas tiene un punto ciego estructural: solo ve lo que alguien ya programó como regla. Un atacante sofisticado diseña su actividad para no disparar esas reglas. Las hunting queries permiten a un analista, de forma manual y dirigida por hipótesis, mirar datos que nadie está alertando todavía — antes de un incidente (proactivamente), durante uno (monitorear el siguiente movimiento) y después de uno (mejorar cobertura con lo aprendido).

## Cómo funciona

Hay dos orígenes: **queries integradas** (llegan con soluciones del Content Hub, mantenidas por investigadores de Microsoft) y **queries personalizadas** (creadas o editadas por el analista, guardables como propias o compartidas con el tenant). El flujo típico: seleccionar/filtrar queries en la pestaña Queries → **Run all queries** o **Run selected queries** → revisar resultados, ordenando por **Results delta** o filtrando por táctica/técnica MITRE ATT&CK → **View query results** abre el panel de Logs, desde donde se puede crear un bookmark. Si una query demuestra valor repetido, se convierte en una custom analytics rule (**New alert rule → Create Microsoft Sentinel alert**) para que alerte automáticamente de ahí en adelante.

## Dónde se configura / rol necesario

Ruta: **Microsoft Sentinel → Threat management → Hunting → pestaña Queries** (disponible tanto en el portal de Azure como en Microsoft Sentinel dentro del portal de Defender). Para ejecutar y ver: **Microsoft Sentinel Reader**. Para crear, editar o compartir queries personalizadas con el tenant: **Microsoft Sentinel Contributor** o superior.

## Ejemplo

Contoso sospecha de una cuenta administrativa. Un analista escribe:

```kql
SecurityEvent
| where EventID == 4624
| where LogonType in (2, 10)
| extend HourOfDay = datetime_part("Hour", TimeGenerated)
| where HourOfDay < 6 or HourOfDay > 22
| project TimeGenerated, Account, Computer, LogonType, IpAddress, HourOfDay
| order by TimeGenerated desc
```

La corre manualmente, sin ninguna alerta configurada — es exploración dirigida por la hipótesis "¿hay actividad administrativa fuera de horario que nadie está mirando?".

## Trampa de examen

Una hunting query, por sí sola, **nunca genera una alerta ni un incidente automáticamente** — necesita convertirse explícitamente en una analytics rule para eso. Un enunciado que pida "avisarme automáticamente de ahora en adelante" nunca tiene como respuesta correcta "dejar la hunting query como está".

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
