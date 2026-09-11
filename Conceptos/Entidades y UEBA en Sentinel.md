---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# Entidades y UEBA en Sentinel

## Definición

Una **entidad** es cualquier objeto identificable dentro de los datos de seguridad — una cuenta, un dispositivo, una IP, un archivo. **UEBA** (User and Entity Behavior Analytics, análisis de comportamiento de usuarios y entidades) es la capacidad de Sentinel que perfila el comportamiento normal de esas entidades para detectar desviaciones. La pestaña **Entities** de un hunt consolida, sin duplicados, todas las entidades que aparecieron en los bookmarks de ese hunt.

## Por qué existe

Revisar bookmarks uno por uno hace fácil perder un patrón como "esta misma cuenta de servicio apareció en tres bookmarks distintos". La pestaña Entities da esa vista agregada sin tener que cruzar manualmente los bookmarks.

## Cómo funciona

La lista se genera automáticamente a partir de las entidades mapeadas en los bookmarks del hunt, con resolución automática de duplicados (la misma entidad mapeada en dos bookmarks aparece una sola vez). Desde ahí se puede: seleccionar el nombre de una entidad para ir a su **página UEBA** (historial de actividad, picos de riesgo), o hacer clic derecho para acciones específicas del tipo de entidad — por ejemplo agregar una IP a Threat Intelligence, o correr un playbook específico de ese tipo de entidad.

## Dónde se configura / rol necesario

Dentro de un hunt abierto, pestaña **Entities**. Rol: **Microsoft Sentinel Contributor** para acciones (playbook, agregar a TI); **Sentinel Reader** alcanza para solo visualizar.

## Ejemplo

En el hunt de Kerberoasting de Contoso, la pestaña Entities revela que la misma cuenta de servicio aparece vinculada a tres de cinco bookmarks distintos — un patrón fácil de perder revisando bookmarks en orden cronológico. Con un clic derecho, el analista ejecuta un playbook que deshabilita esa cuenta de servicio.

## Trampa de examen

La pestaña Entities **no reemplaza** al investigation graph de un bookmark individual: Entities da la lista agregada sin duplicados de todo el hunt; el investigation graph da el diagrama visual de relaciones de un bookmark puntual.

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
