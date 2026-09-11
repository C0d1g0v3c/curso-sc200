---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 9
---
# Action center

**Definición:** pantalla del portal de Microsoft Defender (`security.microsoft.com/action-center`) que centraliza el historial de todas las acciones de respuesta tomadas sobre dispositivos y archivos en el tenant — quién las lanzó, cuándo, sobre qué entidad, y si tuvieron éxito o fallaron.

**Por qué existe:** varias acciones (Collect investigation package, Isolate device, Run antivirus scan) no se completan al instante; el Action center es el lugar para verificar su estado y, en el caso del investigation package, descargar el resultado.

**Cómo funciona:** cada acción de respuesta, manual o automática (incluidas las de Automatic attack disruption), genera una entrada con timestamp, usuario/sistema que la disparó, entidad afectada, y estado (pending/succeeded/failed/skipped).

**Dónde se configura / rol necesario:** no requiere configuración; consultarlo solo requiere "View data". Descargar un investigation package requiere además el permiso que autorizó la acción original.

**Ejemplo:** un analista lanzó Collect investigation package y cerró la pestaña antes de que terminara; vuelve al Action center para descargar el .zip cuando esté listo.

**Trampa de examen:** el Action center NO es un lugar donde se disparan nuevas acciones — es un historial y punto de descarga. Si el enunciado pide "iniciar" una acción, la respuesta está en la página del dispositivo.

## Lecciones donde aparece
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]
