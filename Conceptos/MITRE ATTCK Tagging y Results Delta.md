---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# MITRE ATT&CK Tagging y Results Delta (en Hunting de Sentinel)

## Definición

**MITRE ATT&CK** es un framework público que cataloga las **tácticas** (el objetivo del atacante en una fase del ataque) y **técnicas** (el método concreto para lograrlo) usadas por adversarios reales. En Sentinel, cada hunting query puede etiquetarse con la táctica/técnica que detecta ("MITRE tagging"). **Results delta** es una métrica calculada automáticamente que compara cuántos resultados devolvió una query en las últimas 24 horas contra las 24-48 horas anteriores.

## Por qué existe

Con docenas o cientos de hunting queries disponibles, un analista no puede revisarlas todas a mano cada día. El MITRE tagging resuelve "¿qué áreas de mi superficie de ataque tienen o no cobertura de hunting?"; Results delta resuelve "¿cuál de mis queries cambió de comportamiento recientemente y merece atención primero?". Juntos convierten una lista plana de queries en una lista priorizada.

## Cómo funciona

Cada query trae su táctica/técnica MITRE asociada. Arriba de la tabla de la pestaña Queries hay una barra de tácticas MITRE que cuenta cuántas queries hay mapeadas a cada una, actualizada dinámicamente según los filtros activos. Cada vez que se corren las queries, Sentinel calcula el delta absoluto y porcentual entre el conteo actual y el periodo previo, ordenable en la tabla. Para ver cobertura agregada por técnica (no por query individual), existe la página dedicada **MITRE ATT&CK (Preview)**, filtrable por "Hunting queries" en el menú Simulated.

## Dónde se configura / rol necesario

Vista calculada automáticamente en **Microsoft Sentinel → Threat management → Hunting → pestaña Queries** (barra MITRE y columna Results delta), visible con **Microsoft Sentinel Reader** en adelante. Vista de cobertura agregada: **Microsoft Sentinel → Threat management → MITRE ATT&CK (Preview)**.

## Ejemplo

Un analista de Contoso, al iniciar turno, ordena la pestaña Queries por **Results delta percentage** descendente y revisa primero las 5 queries con mayor cambio. Si alguna toca la táctica "Credential Access" (por el Kerberoasting reciente del Día 11), la prioriza aún más — es triage, no fuerza bruta sobre todas las queries disponibles.

## Trampa de examen

"¿Cómo identifico qué técnicas MITRE ATT&CK NO tienen cobertura de hunting?" no se resuelve revisando query por query — la vía correcta es la página MITRE ATT&CK (Preview) con el filtro de Hunting queries en Simulated, que da la vista agregada por técnica.

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
