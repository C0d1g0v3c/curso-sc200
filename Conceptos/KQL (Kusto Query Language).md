---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 15
---
# KQL (Kusto Query Language)

**Definición:** lenguaje de consulta de solo lectura usado por Microsoft Sentinel (sobre Log Analytics) y Advanced Hunting (sobre el esquema de Defender XDR). Es un lenguaje de flujo de datos: una tabla de origen se transforma con una cadena de operadores conectados por `|` (pipe), donde cada operador recibe el resultado del anterior.

**Por qué existe:** los datos de seguridad llegan en volúmenes de millones de filas/día. KQL es de solo lectura (no modifica datos), lo que permite optimizaciones agresivas, y su sintaxis de tubería hace legible una consulta compleja como una secuencia de pasos.

**Cómo funciona:** operadores clave — `where` (filtra), `summarize` (agrupa y agrega, combinado con `arg_max` para quedarte con la fila más reciente de cada grupo), `let` (define variables reutilizables), `extend` (añade columna conservando el resto) vs `project` (selecciona/renombra, descarta el resto), `has` (busca palabra completa, indexado, rápido) vs `contains` (busca subcadena, sin índice, lento), `parse` (extrae campos de un string con un patrón), `mv-expand` (convierte una columna array/dynamic en varias filas), y `union` vs `join` (ver nota separada).

**Dónde se configura / rol necesario:** Advanced Hunting en `security.microsoft.com` → Investigation & response → Hunting; Logs en Sentinel dentro del workspace de Log Analytics. No requiere "configuración" propia, solo el rol de lectura correspondiente sobre los datos consultados.

**Ejemplo:**
```kql
DeviceProcessEvents
| where Timestamp > ago(1d)
| where FileName has "powershell.exe"
| summarize Count = count() by DeviceId, InitiatingProcessAccountName
| where Count > 10
```

**Trampa de examen:** no confundir KQL con **KeyQL** (Keyword Query Language), el lenguaje de búsqueda de eDiscovery en Purview — son lenguajes distintos para productos distintos, y Copilot traduce lenguaje natural a cada uno por separado (Query assistant → KQL en Advanced Hunting; Copilot en eDiscovery → KeyQL).

## Lecciones donde aparece
- [[Dia 15 - Repaso KQL Advanced Hunting Custom Detections y Hunting Graph]]
