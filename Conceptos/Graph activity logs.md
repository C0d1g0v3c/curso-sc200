---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 13
---
# Graph activity logs

**Definición:** Microsoft Graph activity logs es el registro de cada solicitud HTTP que la API de Microsoft Graph procesa para un tenant: quién la hizo, con qué aplicación, a qué recurso, con qué resultado. Existen dos versiones: `MicrosoftGraphActivityLogs` (completa, vía Log Analytics) y `GraphApiAuditEvents` (gratuita, vía Advanced Hunting).

**Por qué existe:** un atacante puede evitar el portal normal (donde Audit y sign-in logs lo detectarían) y usar directamente llamadas programáticas a la API de Graph con un token OAuth robado. Este log da visibilidad a ese tráfico, invisible para el resto de herramientas de auditoría.

**Cómo funciona:** se activa vía **Diagnostic settings de Azure Monitor**, enviando los logs a Log Analytics, Azure Storage, o Event Hubs. Columnas clave: `OperationId` (agrupa por lote de solicitud), `SignInActivityId` (correlaciona con el inicio de sesión completo, se une contra `UniqueTokenIdentifier` de `SigninLogs`), `UniqueTokenId` (identifica el token específico usado). La alternativa gratuita `GraphApiAuditEvents` vive en el esquema de Advanced Hunting de Defender XDR, se activa con el conector Defender XDR → Sentinel sin licencia adicional, retención fija de 30 días, y no trae `SignInActivityId` (usa `UniqueTokenIdentifier` y `OperationId`).

**Dónde se configura / rol necesario:** requiere licencia **Microsoft Entra ID P1 o P2**. **Security Administrator** es el rol de menor privilegio soportado para configurar diagnostic settings. Destino típico: workspace de Log Analytics, tabla `MicrosoftGraphActivityLogs` (~15 GiB/mes estimado para 1,000 usuarios).

**Ejemplo:**
```kql
MicrosoftGraphActivityLogs
| where TimeGenerated >= ago(3d)
| where ResponseStatusCode in (401, 403)
| where RequestUri contains "/groups"
| summarize UniqueRequests = count_distinct(RequestId) by AppId, ServicePrincipalId, UserId
| sort by UniqueRequests desc
```

**Trampa de examen:** "sin licencia adicional / gratis / 30 días" → `GraphApiAuditEvents`. "Cobertura completa, correlación con sign-in" → `MicrosoftGraphActivityLogs` con columna `SignInActivityId` (no `OperationId`, que solo agrupa lotes de solicitudes).

## Lecciones donde aparece
- [[Dia 13 - Purview Audit eDiscovery Graph Activity Logs y Copilot Embebido]]
- [[Dia 15 - Repaso KQL Advanced Hunting Custom Detections y Hunting Graph]]
