---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# Métricas de un Hunt

## Definición

La **barra de métricas** de la pestaña Hunts (Preview) de Microsoft Sentinel es un panel que cuenta, de forma agregada sobre todos los hunts, cuántas hipótesis se validaron, cuántos incidentes nuevos se crearon a partir de hunts, y cuántas analytics rules nuevas se crearon a partir de hunts.

## Por qué existe

Un programa de threat hunting maduro necesita justificar su valor ante la organización — "encontramos algo" no es una métrica, es una anécdota. La barra de métricas convierte la actividad de hunting en números concretos y acumulables, útiles para fijar metas o mostrar progreso.

## Cómo funciona

Se calcula automáticamente, sin configuración manual: cada vez que un hunt cambia su hipótesis a "validada", cada vez que se crea un incidente desde un hunt, y cada vez que se crea una analytics rule desde un hunt, el contador correspondiente sube.

## Dónde se configura / rol necesario

Vista automática en **Microsoft Sentinel → Threat management → Hunting → pestaña Hunts (Preview)**, visible con **Microsoft Sentinel Reader** en adelante (verla no exige el Contributor que sí requieren crear o modificar hunts).

## Ejemplo

El líder del SOC de Contoso usa la barra de métricas en su revisión trimestral: 12 hunts cerrados, 4 hipótesis validadas, 3 analytics rules nuevas creadas a partir de esos hunts — evidencia concreta de que el tiempo de hunting proactivo generó detecciones permanentes.

## Trampa de examen

Las métricas cuentan resultado accionado (hipótesis validada + acción tomada), no actividad bruta — correr muchas queries sin nunca validar una hipótesis ni crear una rule/incidente no mueve estos contadores.

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
