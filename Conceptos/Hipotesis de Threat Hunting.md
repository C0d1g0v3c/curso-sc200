---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# Hipótesis de Threat Hunting

## Definición

Una **hipótesis** de threat hunting es una idea concreta y verificable sobre una posible amenaza en el entorno — algo que se puede validar o descartar con datos, no una sospecha vaga. Es el primer paso formal del flujo de trabajo de la función **Hunts** de Microsoft Sentinel.

## Por qué existe

Sin una hipótesis clara, "hacer hunting" se vuelve mirar datos sin rumbo — improductivo y difícil de medir. Definir la hipótesis antes de escribir la primera query obliga a decidir qué se está buscando y por qué, y da a la investigación un criterio de éxito claro: ¿la hipótesis se validó o no?

## Cómo funciona

Microsoft Learn define tres puntos de partida típicos: **comportamiento sospechoso** (algo visible en el entorno que se quiere confirmar — se arranca corriendo todas las queries y ordenando por Results delta), **nueva campaña de amenaza** (una amenaza recién conocida — se arranca instalando una solución específica del Content Hub) y **brecha de detección** (un hueco en la cobertura MITRE ATT&CK — se arranca en la página MITRE ATT&CK (Preview) filtrando técnicas sin hunting queries asociadas). La hipótesis se redacta como texto libre al crear el hunt, y su estado (validada / no validada / en progreso) se actualiza por separado desde un menú dedicado a medida que avanza la investigación.

## Dónde se configura / rol necesario

Campo **Description** al crear un hunt: **Microsoft Sentinel → Threat management → Hunting → pestaña Hunts (Preview) → New Hunt**. El estado de la hipótesis se actualiza desde un menú desplegable dentro del hunt ya creado. Rol: **Microsoft Sentinel Contributor**.

## Ejemplo

Contoso lee una noticia sobre una campaña activa de Kerberoasting contra organizaciones similares. El analista redacta la hipótesis: "Contoso podría tener cuentas de servicio con SPNs débiles expuestas a Kerberoasting, y Sentinel no tiene visibilidad independiente de eso fuera de MDI" — concreta y verificable.

## Trampa de examen

El estado de una hipótesis (validada/no validada) **no cierra automáticamente el hunt** — son dos campos independientes: uno describe el resultado de la investigación, el otro si el trabajo sigue activo.

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
