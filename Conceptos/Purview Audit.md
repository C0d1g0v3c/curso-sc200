---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 13
---
# Purview Audit

**Definición:** Microsoft Purview Audit (unified audit log) es el registro centralizado de miles de operaciones de usuario y admin en Microsoft 365 (abrir archivo, compartir enlace, cambiar permiso, iniciar sesión, eliminar buzón). Existe en dos niveles: Audit (Standard) y Audit (Premium), donde Premium incluye toda la funcionalidad de Standard y añade retención extendida, políticas de retención personalizadas y los "Intelligent insights".

**Por qué existe:** sin un log centralizado, reconstruir "qué pasó" requeriría revisar logs dispersos de cada app por separado. Audit unifica esas operaciones en un solo lugar buscable para investigaciones forenses, de IT, de cumplimiento y legales.

**Cómo funciona:** cada operación auditable genera un audit record que se guarda en el unified audit log. Standard retiene 180 días (cambió de 90 días el 17-oct-2023). Premium retiene 1 año por defecto para Entra ID/Exchange/OneDrive/SharePoint, hasta 10 años con add-on, y añade "Intelligent insights" — eventos que Standard **no registra en absoluto**: `MailItemsAccessed` (con propiedad `SensitivityLabel`) en Exchange Online, y varios eventos de Teams (`ChatCreated`, `MessageSent`, `MeetingParticipantDetail`, etc.) con propiedades como `AppAccessContext`.

**Dónde se configura / rol necesario:** búsqueda en `purview.microsoft.com` → Audit → Search. Roles: **Audit Logs** o **View-Only Audit Logs** (en el Purview portal; para PowerShell, el mismo rol asignado en Exchange admin center). Cmdlet: `Search-UnifiedAuditLog` (Exchange Online PowerShell), con `-RecordType` para filtrar por producto. Límite: 180 días máximo por búsqueda, hasta 10 search jobs en paralelo, exportación de 50,000 filas (Standard) o 1,000,000 (Premium).

**Ejemplo:** confirmar si una cuenta comprometida con Audit Premium leyó correos financieros antes de revocarle el acceso, filtrando `Search-UnifiedAuditLog -Operations MailItemsAccessed -RecordType ExchangeItem`. Si la cuenta no tuviera licencia Premium, el evento simplemente no existiría en los resultados.

**Trampa de examen:** el examen pregunta la retención "por defecto" esperando 180 días (no 90, valor viejo). También pregunta por `RecordType == "AirInvestigation"` para eventos de AIR (Automated Investigation and Response) — y AIR de Defender for Office 365 sigue vigente después del retiro de AIR de MDE (1-sep-2026).

## Lecciones donde aparece
- [[Dia 13 - Purview Audit eDiscovery Graph Activity Logs y Copilot Embebido]]
