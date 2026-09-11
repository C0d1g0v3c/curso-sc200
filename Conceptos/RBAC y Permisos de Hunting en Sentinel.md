---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# RBAC y Permisos de Hunting en Sentinel

## Definición

**RBAC** (Role-Based Access Control, control de acceso basado en roles) es el modelo de Azure que decide qué puede hacer cada usuario según el rol asignado sobre un recurso — en este caso, sobre el workspace de Sentinel o sobre el hunt específico. Para hunting existen roles nativos escalonados: Microsoft Sentinel Reader, Responder y Contributor.

## Por qué existe

No todos los miembros del SOC deben tener el mismo nivel de acceso al contenido de hunting — un analista junior puede necesitar solo ver y correr queries, mientras que uno senior necesita poder crear hunts, bookmarks y convertir hallazgos en reglas permanentes. RBAC aplica el principio de mínimo privilegio.

## Cómo funciona

Azure evalúa, para cada acción que un usuario intenta, si su rol asignado sobre el recurso incluye el permiso necesario. Jerarquía relevante para hunting: **Microsoft Sentinel Reader** (ver queries, bookmarks, métricas — solo lectura) → **Microsoft Sentinel Responder** (+ investigar bookmarks, escalar a incidente) → **Microsoft Sentinel Contributor** (+ crear/editar hunting queries, crear/editar bookmarks, crear/gestionar Hunts, crear analytics rules). Alternativa granular: un rol RBAC personalizado con permisos sobre el ámbito `Microsoft.SecurityInsights/hunts`, equivalente a Contributor pero acotado solo a Hunts.

## Dónde se configura / rol necesario

**Azure Portal → suscripción o resource group → Access control (IAM) → Add role assignment**, seleccionando el rol nativo de Sentinel y el usuario/grupo. Para usar la función Hunts específicamente: **Microsoft Sentinel Contributor** o el rol personalizado sobre `Microsoft.SecurityInsights/hunts` — Sentinel Reader no alcanza.

## Ejemplo

Contoso asigna **Sentinel Reader** a analistas Tier 1 (triage), **Sentinel Responder** a Tier 2 (investigación activa) y **Sentinel Contributor** solo a Tier 3 (hunting proactivo dedicado), porque son los únicos que crean hunts completos y convierten hallazgos en detecciones permanentes.

## Trampa de examen

"Sentinel Reader es suficiente porque Hunts solo lee datos" es un distractor falso: Hunts crea objetos nuevos (el hunt, sus queries clonadas, sus bookmarks), así que exige un rol con permisos de escritura.

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
