---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 16
---

# Bookmark de Hunting en Sentinel

## Definición

Un **bookmark** (marcador) es un objeto de Microsoft Sentinel que preserva una fila concreta de resultados de una hunting query, junto con la query completa que la generó, en un registro permanente que puede anotarse, etiquetarse y volver a consultarse — sin depender de re-correr la query original con el mismo rango de tiempo.

## Por qué existe

Cazar amenazas implica revisar montañas de datos. Cuando una fila parece relevante — un proceso raro, una IP sospechosa, un patrón de login fuera de horario — se necesita preservarla de forma que todo el equipo pueda consultarla y correlacionarla en KQL, no solo una captura de pantalla suelta.

## Cómo funciona

1. Se corre una hunting query y se selecciona **View query results**, que abre el panel de **Logs**.
2. Se marcan los checkboxes de las filas de interés.
3. Se selecciona **Add bookmark** — crea un bookmark por cada fila marcada, con el resultado y la query que lo generó.
4. Opcionalmente se agregan nombre, tags, notas, mapeo de entidades y técnicas/tácticas MITRE ATT&CK (heredadas por defecto de la query origen, editables).

Un bookmark puede: verse en la pestaña **Bookmarks** (filtrable por tag), investigarse en el **investigation graph** (requiere al menos una entidad mapeada), escalarse a un incidente (**Incident actions → Create new incident / Add to existing incident**), consultarse en crudo en la tabla **`HuntingBookmark`** de Log Analytics, o borrarse (la fila más reciente de `HuntingBookmark` pasa a `SoftDelete == true`, no desaparece físicamente).

## Dónde se configura / rol necesario

**Solo se CREAN en el portal de Azure**, dentro de **Microsoft Sentinel → Threat management → Hunting**. En el portal de Defender (`security.microsoft.com`) solo se pueden **ver** bookmarks ya creados, nunca crear uno nuevo — restricción real de plataforma, no de configuración. Rol: **Microsoft Sentinel Contributor** para crear/editar; **Microsoft Sentinel Responder** alcanza para escalar uno existente a incidente; **Microsoft Sentinel Reader** solo permite verlos.

## Ejemplo

Un analista encuentra, en los resultados de una hunting query, una cuenta administrativa con logon a las 3:14 AM desde una IP desconocida. Marca la fila, selecciona **Add bookmark**, escribe la nota "IP no reconocida, fuera de horario — validar antes de escalar", y mapea las entidades `Account` e `IP address`. Con al menos una entidad mapeada, puede abrir el bookmark en el investigation graph.

## Trampa de examen

Si el enunciado dice explícitamente que el analista está en el portal de Defender e intenta crear un bookmark nuevo desde ahí, la respuesta correcta nunca es "lo crea sin problema" — tiene que cambiar al portal de Azure primero.

## Lecciones donde aparece

- [[Dia 16 - Hunting en Sentinel Queries Bookmarks y Hunts]]
