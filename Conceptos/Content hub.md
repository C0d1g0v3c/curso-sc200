---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# Content hub

**Definición:** catálogo centralizado de contenido de seguridad listo para usar dentro de Microsoft Sentinel: soluciones completas o piezas sueltas (workbooks, analytics rules, playbooks, parsers) empaquetadas por Microsoft o terceros para un producto o escenario concreto.

**Por qué existe:** construir cada detección y cada workbook desde cero para cada fabricante conectado sería un desperdicio de tiempo. El Content hub da el punto de partida ya armado.

**Cómo funciona:** se instala una "solución" (por ejemplo, "Palo Alto Networks" o "Microsoft Entra ID"), lo que trae consigo sus workbooks, reglas y parsers asociados, listos para personalizar.

**Dónde se configura / rol necesario:** Microsoft Sentinel > Content management > Content hub. Gestionar contenido requiere Microsoft Sentinel Contributor a nivel de resource group.

**Ejemplo:** instalar la solución de Microsoft Entra ID añade automáticamente los workbooks "Microsoft Entra sign-ins" y "Microsoft Entra audit logs".

**Trampa de examen:** una plantilla de workbook puede requerir tipos de datos concretos (campo "Required data types") — si no los ingieres, el workbook se abre vacío aunque la solución esté instalada.

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
