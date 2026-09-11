---
tags: [sc-200, concepto]
dominio: "Dominio 1 y 3"
dia_origen: 15
---
# Advanced Hunting

**Definición:** motor de búsqueda basado en KQL dentro del portal de Microsoft Defender XDR, que da acceso directo al esquema de más de 60 tablas de eventos crudos de todos los productos Defender (MDE, MDO, MDCA, MDI) más algunas tablas de Sentinel y de Microsoft Security Exposure Management.

**Por qué existe:** las alertas ya generadas (`SecurityAlert`/`AlertInfo`) muestran solo lo que un producto decidió reportar. Advanced Hunting da acceso a los eventos crudos subyacentes, para que un analista pueda buscar patrones que ningún producto marcó todavía como alerta — es la base tanto de la investigación manual como de las custom detection rules.

**Cómo funciona:** las tablas se agrupan por familia según el tipo de entidad/producto: `Device*` (MDE), `Email*`/`Message*` (MDO/Teams), `Identity*` (MDCA+MDI+AD), `Cloud*` (Defender for Cloud Apps/Defender for Cloud), `Alert*` (alertas e IOCs vinculados), `GraphAPIAuditEvents` (tráfico de Graph API), `Exposure*` (Microsoft Security Exposure Management). Cada tabla tiene su propia lista de columnas y valores de `ActionType`.

**Dónde se configura / rol necesario:** `security.microsoft.com` → Investigation & response → Hunting → Advanced hunting. Requiere un rol de Entra ID con permisos de lectura sobre los datos consultados (varía según qué tablas de qué producto se consulten).

**Ejemplo:**
```kql
DeviceProcessEvents
| where Timestamp > ago(1d)
| where ProcessCommandLine has "powershell" and ProcessCommandLine has "-enc"
| project Timestamp, DeviceName, AccountName, ProcessCommandLine
```

**Trampa de examen:** no todas las tablas de Advanced Hunting soportan todas las capacidades (ej. no todas son elegibles para Continuous NRT en custom detection rules) — ver [[Conceptos/Custom detection rule]]. Tampoco todas las tablas "suenan" al producto correcto: `IdentityLogonEvents` mezcla datos de MDCA y de MDI, no es exclusiva de uno.

## Lecciones donde aparece
- [[Dia 15 - Repaso KQL Advanced Hunting Custom Detections y Hunting Graph]]
