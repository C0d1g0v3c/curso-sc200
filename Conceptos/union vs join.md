---
tags: [sc-200, concepto]
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
dia_origen: 15
---
# union vs join

**Definición:** dos operadores de KQL para combinar datos de más de una tabla, pero con mecánicas opuestas. `union` **apila filas**: junta todas las filas de dos o más tablas una debajo de otra, sin necesidad de ninguna condición de coincidencia; el resultado tiene la unión de todas las columnas de ambas tablas (celdas vacías/`null` donde una tabla no tenía esa columna). `join` **combina columnas** de dos tablas basándose en una **clave que coincide** entre ambas; el resultado tiene una fila por cada coincidencia encontrada, con columnas de ambas tablas lado a lado.

**Por qué existe la confusión:** ambos "juntan dos tablas", pero responden preguntas distintas. `union` responde "dame todos los eventos de este tipo, sin importar en qué tabla estén" (mismo tipo de dato repartido en varias tablas por alguna razón técnica — ej. sign-in interactivo vs no interactivo). `join` responde "enriquece esta fila con datos relacionados que viven en otra tabla" (dos tipos de dato distintos, relacionados por un identificador común).

**Cómo funciona:**
```kql
// union: junta SigninLogs y AADNonInteractiveUserSignInLogs (mismo tipo de evento, dos tablas)
union SigninLogs, AADNonInteractiveUserSignInLogs
| where TimeGenerated > ago(7d)
```
```kql
// join: correlaciona MicrosoftGraphActivityLogs con el sign-in que lo originó, por una clave común
MicrosoftGraphActivityLogs
| join kind=leftouter (SigninLogs) on $left.SignInActivityId == $right.UniqueTokenIdentifier
```

**Dónde se usa / regla práctica:** si las tablas tienen **el mismo esquema o esquema muy parecido** y no hay una clave de relación que buscar → `union`. Si necesitas **cruzar dos tipos de dato distintos por un identificador compartido** → `join`.

**Ejemplo real de este curso:** el Ejemplo 1 del Día 13 usa `union` para juntar cuatro tablas de sign-in (`SigninLogs`, `AADNonInteractiveUserSignInLogs`, `AADServicePrincipalSignInLogs`, `AADManagedIdentitySignInLogs` — todas "el mismo tipo de evento" repartido por tipo de identidad) y después un `join` contra `MicrosoftGraphActivityLogs` para correlacionar por `SignInActivityId`/`UniqueTokenIdentifier`.

**Trampa de examen:** una query que usa `union` de varias tablas de sign-in **no es elegible para la frecuencia Continuous (NRT)** de una custom detection rule, aunque las tablas individuales sí estén en la lista de tablas soportadas — el requisito de NRT es "una sola tabla, sin `join` ni `union`" sobre la query completa. Confundir cuál operador usar (o asumir que cualquiera de los dos sirve igual) es el error más repetido de este alumno en el curso — siempre preguntar primero "¿estas tablas tienen una clave de relación que buscar, o son el mismo tipo de evento repartido en varias tablas?".

## Lecciones donde aparece
- [[Dia 13 - Purview Audit eDiscovery Graph Activity Logs y Copilot Embebido]]
- [[Dia 15 - Repaso KQL Advanced Hunting Custom Detections y Hunting Graph]]
