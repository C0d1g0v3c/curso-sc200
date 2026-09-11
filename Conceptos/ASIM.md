---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# ASIM (Advanced Security Information Model)

**Definición:** modelo de normalización de Microsoft Sentinel — un conjunto de parsers ("traductores") que presentan datos de fuentes distintas bajo un mismo esquema de columnas con nombres unificados.

**Por qué existe:** sin normalización, cada fabricante manda logs con nombres de columna distintos. Una consulta escrita contra la tabla nativa de un fabricante se rompe si cambias de proveedor o añades uno nuevo. ASIM pone una capa intermedia normalizada.

**Cómo funciona:** escribes la consulta una vez contra el esquema normalizado (por ejemplo `_Im_NetworkSession`), y el parser traduce cada fuente real a ese esquema común, sin importar el fabricante.

**Dónde se configura / rol necesario:** se usa al escribir consultas de workbooks, analytics rules o hunting queries, seleccionando el parser ASIM correspondiente en lugar de la tabla nativa. No requiere rol especial adicional al de lectura del workspace.

**Ejemplo:** un workbook que usa `_Im_NetworkSession` sigue funcionando sin reescribirse aunque mañana cambies de fabricante de firewall.

**Trampa de examen:** si el enunciado dice "la consulta debe seguir funcionando si cambiamos de fabricante", la respuesta es "usar un parser ASIM", no "escribir contra la tabla nativa".

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
