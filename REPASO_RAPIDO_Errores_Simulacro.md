---
title: Repaso Rápido — Errores del Practice Assessment Oficial (23-jul-2026)
tipo: Hoja de repaso
relacionado: "[[TRACKER_TUTOR]], [[GUIA_INTENSIVA_24_DIAS]], [[CHEATSHEET_KQL]]"
---

# 🎴 Repaso Rápido — Errores del Simulacro (Practice Assessment oficial, 46%)

> Léela en cualquier momento libre (fila del súper, antes de dormir, entre lecciones). Formato pregunta → respuesta, tapa la respuesta y contesta de memoria. Basada en los 24 errores reales de tu intento del 23-jul-2026.

## 1. Workbook vs Playbook (te lo confundió el examen 2 veces — el más barato de arreglar)

1. **¿Qué usas para VISUALIZAR datos / crear un reporte/dashboard?** → Workbook.
2. **¿Qué usas para EJECUTAR una acción automatizada (aislar, notificar, bloquear)?** → Playbook.
3. **Regla mental:** si la pregunta dice "visualize", "report", "dashboard" → workbook, nunca playbook.

## 2. RBAC y mínimo privilegio

4. **Sentinel necesita ejecutar un playbook que vive en un resource group. ¿Dónde delegas el rol Microsoft Sentinel Automation Contributor?** → Sobre el **resource group** completo, NO sobre el playbook individual (aunque suene "más mínimo privilegio").

## 3. Tablas de ingestión / conectores

5. **¿En qué tabla verificas ingestión del conector Entra ID Protection?** → `SecurityAlert` (no `CommonSecurityLog`, esa es para CEF/appliances).
6. **Ingerir threat indicators curados por Microsoft con MÍNIMO esfuerzo de configuración (ya tienes licencia Defender TI Premium)** → Instalar la solución Threat Intelligence + habilitar el conector **Premium Defender TI** prearmado (NO la Upload API manual — esa es la opción de MÁS esfuerzo).

## 4. Analytics rules y Entra ID Protection

7. **¿Qué tipo de analytics rule necesitas si vas a usar entity mapping?** → **Scheduled** (o NRT). Las reglas ML/Anomaly no tienen ese asistente configurable.
8. **"High-risk users que hicieron un password reset en los últimos 14 días"** → **Risky users report** (por usuario a través del tiempo), NO Risky sign-ins report (eso es por evento puntual de login).

## 5. Portales de compliance/DLP

9. **¿Dónde revisas alertas DLP?** → **Purview portal** + **Defender portal** (unificado). NO en SharePoint admin center ni Microsoft 365 admin center — esos no muestran alertas DLP.

## 6. MDE — acciones de respuesta (tu bloque más débil: 5 errores)

10. **Revisar eventos ANTES de que se disparara una alerta en un dispositivo** → **Timeline** del dispositivo (cronológico, directo). NO Advanced Hunting (eso es para buscar libremente, no para "antes de la alerta" en un solo host).
11. **Analizar remotamente EN VIVO un proceso sospechoso (shell interactivo)** → **Live response**. NO Advanced hunting (solo consulta telemetría ya recolectada, no te deja "tocar" nada).
12. **Identificar quién inició sesión INTERACTIVAMENTE en un dispositivo durante un ataque** → **Timeline**. NO la tabla `IdentityInfo` (esa es un directorio estático, no un registro de logons por dispositivo).
13. **Capturar memoria + procesos + red, MINIMIZANDO impacto al usuario y evitando falsos positivos** → **Collect investigation package** (forense pasivo). NO Isolate device (aislar SÍ corta la red del usuario — impacto directo que el enunciado pedía evitar).
14. **Identificar el ALCANCE de un incidente en dispositivos Windows 11 y macOS** → **Advanced hunting** (consulta libre cross-SO). NO Deep analysis (eso es sandbox de UN archivo, no "alcance" de incidente).

> **Patrón de este bloque:** cuando el enunciado da un calificador ("minimizar impacto", "antes de la alerta", "en vivo"), ese calificador casi siempre elimina la opción más "genérica/poderosa" (Isolate, Advanced hunting) a favor de la más quirúrgica para ese caso puntual.

## 7. Purview Audit / eDiscovery / Graph activity logs (contenido del Día 13 — normal fallar esto hoy)

15. **Usuario externo accedió a un doc de SharePoint con info confidencial — identificar quién y qué hizo** → **Purview portal → audit log search**. NO una query ASIM en Sentinel (sin conector adicional, Sentinel no tiene esa visibilidad nativa).
16. **¿User1 inició sesión y compartió un doc de OneDrive en los últimos 30 días?** → **Purview portal**. NO el Defender portal (ese es para incidentes/alertas de seguridad, no auditoría de actividad de usuario).
17. **Buscar en el unified audit log actividades de Defender XDR** → tipo de registro **`AirInvestigation`**. NO `AzureActiveDirectory` (cada producto tiene su propio RecordType).
18. **eDiscovery falla con error CS007 (demasiados resultados / wildcards) — mantener el resultado manejable** → **Dividir la búsqueda en rangos de tiempo o ubicaciones más pequeños**. NO "quitar objetos de buzón duplicados con Get-Recipient" (eso resuelve ambigüedad de destinatarios, no volumen).
19. **Graph activity logs — identificar llamadas hechas por el MISMO access token** → atributo **`SignInActivityId`**. NO `OperationId` (identifica una operación individual, no la sesión/token completo).

## 8. KQL / Advanced Hunting — detalles finos de esquema

20. **Columnas que debe devolver una query para crear una custom detection rule** → **`ReportId` + `Timestamp`** (las dos exigidas por Defender XDR para trazabilidad). `AlertId` NO es una columna de salida válida para esto.
21. **¿`DeviceEvents` incluye dispositivos Android onboardeados?** → **NO.** `DeviceEvents` es de escritorio (Windows/macOS/Linux), no de móviles, aunque el dispositivo Android esté onboardeado a Defender.
22. **Buscar la misma IP ACROSS varias tablas y devolver todas las coincidencias** → operador **`union`** (apila filas de varias tablas). NO `join` (eso cruza columnas entre DOS tablas por una clave común — es para relacionar, no para "buscar en todos lados").
23. **Nombre real de columna para detectar un ActionType específico en `DeviceEvents`** → siempre sigue el patrón **`ActionType == "..."`**. Desconfía de nombres "razonables pero inventados" como `EventType` — no existen en el esquema real.

## 9. Sentinel MCP Server / Data lake (contenido del Día 17 — normal fallar esto hoy)

24. **MCP tool calls autenticando al tenant equivocado (cuenta guest)** → agregar el header **`x-mcp-client-tenant-id`** en la definición del servidor MCP. NO guardar un access token estático en `.vscode/mcp.json` (antipatrón de seguridad, no resuelve el problema de tenant).
25. **MCP tool calls devolviendo resultados de un workspace equivocado en el data lake** → usar **`'default'` como `workspaceId`** en el prompt. NO usar la tool `list_sentinel_workspaces` para especificarlo manualmente cada vez.

---

## 🧠 Los 3 hábitos a corregir (resumen de resumen)

1. **Lee el calificador del enunciado antes de mirar las opciones** — "minimize effort", "minimize impact", "before the alert", "least privilege" — casi siempre decide la respuesta.
2. **No confundas herramientas con propósitos parecidos**: workbook≠playbook · Timeline≠Advanced Hunting≠Isolate · Purview Audit≠eDiscovery≠Sentinel.
3. **Desconfía de nombres de columna "razonables"** en las opciones de KQL — memoriza los reales (`ActionType`, `ReportId`, `SignInActivityId`) en vez de reconocer por lógica.

*Fuente: revisión completa de tu intento del Practice Assessment oficial, 23-jul-2026 (score 46%). Ver detalle completo en [[TRACKER_TUTOR]]. Repite el simulacro en el Día 22 del plan — meta ≥80%.*
