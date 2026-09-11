---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# Workbook

**Definición:** un workbook es un informe visual interactivo de Microsoft Sentinel: una página de bloques de texto, gráficas, tablas y filtros donde cada gráfica se alimenta de una consulta KQL que se ejecuta en el momento de abrir la página. Está construido sobre el motor de Azure Monitor Workbooks.

**Por qué existe:** para no tener que reescribir y volver a correr una consulta KQL a mano cada vez que quieres ver un dato actualizado. El workbook empaqueta consulta + visualización + filtros en una página reutilizable.

**Cómo funciona:** cada workbook es un recurso de Azure (como una VM), vive en el resource group del workspace de Sentinel, y se guarda como un archivo JSON — solo la definición de la consulta, nunca los datos. Los datos se leen en vivo del Log Analytics workspace cada vez que se abre.

**Dónde se configura / rol necesario:** Sentinel > Threat management > Workbooks. Ver = Workbook Reader sobre el resource group. Editar = Workbook Contributor. Crear/eliminar = Microsoft Sentinel Contributor (o rol menor) **Y ADEMÁS** Workbook Contributor — los dos roles combinados.

**Ejemplo:** el workbook "Microsoft Entra sign-ins" muestra inicios de sesión fallidos por país y aplicación, con un parámetro TimeRange que recalcula las gráficas al cambiar el rango de fechas.

**Trampa de examen:** confundir workbook (visualizar) con playbook (ejecutar acciones). Verbo delator: "mostrar/reporte/dashboard" = workbook; "automatizar/ejecutar" = playbook. También: crear un workbook exige DOS roles combinados, no uno solo.

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
