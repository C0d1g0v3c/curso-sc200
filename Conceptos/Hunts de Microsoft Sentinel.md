---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# Hunts de Microsoft Sentinel

## Definición

**Hunts** es una función de Microsoft Sentinel, en **preview**, que agrupa una hipótesis, un conjunto de hunting queries persistidas (clonadas del workspace general), los bookmarks generados, las entidades recolectadas y los comentarios de colaboración en un solo contenedor de investigación con seguimiento de progreso.

## Por qué existe

Cada query y cada bookmark, sueltos, no mantienen el contexto agregado de una investigación que crece con el tiempo (varias hipótesis, decenas de queries, docenas de bookmarks). Hunts existe para no tener que reconstruir manualmente "¿qué había encontrado la semana pasada sobre esto?" cada vez que se retoma un caso.

## Cómo funciona

Ciclo completo: (1) definir la hipótesis; (2) crear el hunt — desde queries ya seleccionadas (**Hunt actions → Create new hunt**, las clona automáticamente) o en blanco (**Hunts (Preview) → New Hunt**); (3) trabajar dentro de sus tres pestañas propias — **Queries** (clones independientes del workspace, editables sin afectar al resto, con acción directa **Create analytics rule**), **Bookmarks** (mismo flujo que un bookmark normal, vinculado al hunt) y **Entities** (vista consolidada); (4) colaborar con comentarios; (5) crear incidentes desde bookmarks del hunt o desde **Hunt Actions → Create incident**; (6) actualizar el estado de la hipótesis y cerrar el hunt cuando ya se generaron todas las acciones necesarias.

## Dónde se configura / rol necesario

Ruta: **Microsoft Sentinel → Threat management → Hunting → pestaña Hunts (Preview)**. Rol: **Microsoft Sentinel Contributor**, o un rol RBAC personalizado con permisos sobre `Microsoft.SecurityInsights/hunts` — un rol de solo lectura no alcanza, porque Hunts crea objetos nuevos.

## Ejemplo

Contoso investiga cobertura de Kerberoasting. Crea un hunt llamado "Cobertura Kerberoasting - Sentinel" con la hipótesis correspondiente, agrega una query nueva a su pestaña Queries, bookmarkea hallazgos, revisa la pestaña Entities para detectar una cuenta de servicio repetida en varios bookmarks, valida la hipótesis (SPNs débiles encontrados), crea una analytics rule desde la query del hunt, y cierra el hunt — la barra de métricas suma la regla nueva a su conteo.

## Trampa de examen

Editar una query dentro de un hunt **no afecta** a la query general del workspace ni a las de otros hunts, precisamente porque son clones independientes — un distractor típico asume que comparten instancia.

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
