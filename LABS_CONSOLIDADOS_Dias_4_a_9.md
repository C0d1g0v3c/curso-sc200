---
title: Guía de ejecución — Labs consolidados Días 4 a 9
tipo: Guía de laboratorio
creado: 2026-08-23
relacionado: "[[PLAN_MAESTRO_MULTITRACK]], [[TRACKER_TUTOR]]"
---

# 🔬 Labs consolidados — Días 4, 5, 6, 7, 8 y 9

> [!warning] Por qué existe esta nota
> Seis lecciones (Días 4-9) tienen el quiz y la lectura cerrados pero el **lab práctico sigue pendiente en las seis**. Los dos sábados diseñados para pagar esa deuda (15-ago y 22-ago) se cayeron por completo — cero labs hechos en tres semanas. Esta nota junta los seis en el orden más eficiente para hacerlos de corrido, agrupados por **el recurso que comparten**, no por el orden cronológico en que se impartieron las lecciones. No sustituye las lecciones originales (ahí está toda la teoría, los ejemplos y el quiz) — solo consolida la sección "🧪 Ejercicio práctico" de cada una en una secuencia ejecutable.

---

## 0. El número real: no cabe en un sábado

Cada lección ya trae su propia checklist de lab. Sumando los pasos reales (no una estimación optimista), esto es lo que cuesta:

| Día | Contenido del lab | Tiempo estimado |
|---|---|---|
| 4 | Scheduled rule desde plantilla + desde cero, explorar Anomalies, duplicar una regla, blade MITRE | ~50 min |
| 6 | Automation rule + playbook (Logic App) + resolver permisos + revisar Attack Disruption + query KQL | ~55 min |
| 7 | Workbook desde plantilla + desde cero + auto refresh + SOC optimization + roles/IAM + notificaciones + alert tuning | ~85 min |
| 5 | Explorar ASR rules + Advanced features + crear device group + revisar Custom data collection | ~50 min |
| 8 | Manage incident pane + explorar Cases + RBAC + límites de servicio | ~48 min |
| 9 | Roles de MDE + prerrequisitos de Live response + Timeline + Collect investigation package | ~60 min |

**Total: ~5h48min.** El bloque grande del sábado está diseñado para 2-3 horas. No cabe en uno — y prometerlo sería repetir el mismo error que ya causó el atraso (planificar sin contar con la semana real). Se divide en **dos bloques de sábado**, agrupados por el recurso que usan, para no estar prendiendo y apagando tenants distintos a media sesión.

---

## 1. Los dos recursos (no los mezcles)

Este curso usa **dos entornos separados**, y la regla de no tocar uno con el otro ya está fijada desde el Día 1:

| Recurso | Para qué | Días que lo usan |
|---|---|---|
| **Suscripción Azure for Students** (Log Analytics workspace + Sentinel, dentro del tenant Entra de La Salle pero como recurso de Azure aislado) — portal `portal.azure.com` | Todo lo de **Sentinel**: analytics rules, automation rules, playbooks, workbooks, roles IAM sobre el resource group | **4, 6, 7** |
| **Trial M365 E5 personal** (tenant separado, NO el de La Salle) — portal `security.microsoft.com` | Todo lo de **Microsoft Defender for Endpoint** y el portal unificado de Defender: ASR rules, advanced features, device groups, manage incident pane, cases, roles de MDE, live response, timeline | **5, 8, 9** |

No toques la configuración M365 del tenant universitario de La Salle en ningún lab — regla vigente desde el Día 1. Si en algún paso el portal unificado de Defender aparece limitado en un tenant (ya pasó antes con Cases y con custom data collection), la propia lección ya trae una alternativa documentada: leer la sección correspondiente de Microsoft Learn en vez de ejecutarlo en vivo, y anotar la limitación como hallazgo, no como lab fallido.

---

## 2. Bloque A — Sentinel / Azure Portal (Días 4, 6, 7)

**Duración real estimada: ~3h10min** — ligeramente por encima del rango de 2-3h del bloque grande. Si el sábado se alarga o el tiempo aprieta, la sección 2.4 de abajo dice qué recortar primero sin perder lo que realmente se está midiendo.

**Requisito único:** el workspace de Log Analytics + Sentinel de los Días 1-3, ya con datos en `SecurityEvent` y `Syslog`. **No hace falta encender la VM del Día 2** para ninguno de estos tres labs — los datos ya ingeridos bastan. Si de todos modos la enciendes para generar tráfico fresco, déjala en **"Stopped (deallocated)"** al cerrar la sesión.

### 2.1 Día 4 — Analytics rules y Anomalies (~50 min)

1. **Crear una Scheduled rule desde plantilla.** Analytics → Rule templates → elige una plantilla sobre `SigninLogs` o `Syslog`. Completa el asistente entero: General (nombre, severidad, táctica/técnica MITRE), Set rule logic (KQL, lookback), Incident settings, Automated response.
2. **Crear una regla desde cero**, adaptando la query del Ejemplo 1 de la lección a `Syslog` o `SecurityEvent` reales.
3. **Explorar Anomalies:** abre 2-3 reglas, lee Description/Parameters/Threshold, identifica cuál está en Production.
4. **Duplicar una anomaly rule** (right-click → Duplicate) solo para confirmar el flujo: sufijo "- Customized", Flighting, Disabled.
5. **Blade de MITRE ATT&CK:** alterna Active vs Simulated, identifica al menos 2 técnicas sin cobertura activa.

**Evidencia que cierra el lab:**
- La Scheduled rule del Paso 1 aparece en Analytics → Active rules, habilitada.
- La regla del Paso 2 corre sin error de sintaxis contra datos reales — anota cuántas filas devolvió.
- Existe una copia "- Customized" en Flighting/Disabled (Paso 4).
- Lista de al menos 2 técnicas MITRE sin cobertura activa (Paso 5).

### 2.2 Día 6 — Automation rules y Playbooks (~55 min)

1. **Automation rule:** Automation → Create → Automation rule. Trigger "When incident is created", condición Severity equals High, acciones "Change status" a Active + "Add tag" = `Revisado-Dia6`. Order = 1.
2. **Playbook mínimo:** Automation → Playbooks → Add playbook (Consumption). Logic App con trigger "Microsoft Sentinel incident" y un paso simple (Compose, o Teams si está disponible).
3. **Conectar el playbook a la automation rule.** Vuelve a la regla del Paso 1, agrega la acción "Run playbook". Si aparece en gris, sigue "Manage playbook permissions" y otorga **Microsoft Sentinel Automation Contributor** sobre el **resource group** (no sobre el playbook individual — la trampa de RBAC que ya se explicó en la lección).
4. **Attack Disruption (portal de Defender):** Settings → Microsoft Defender XDR → Attack disruption. Si tu tenant lo expone, revisa qué acciones están habilitadas. Si está limitado, documenta el hallazgo y lee [Configure attack disruption capabilities](https://learn.microsoft.com/en-us/defender-xdr/configure-attack-disruption) en su lugar — no te quedes atascado aquí.
5. **Query de verificación** contra `SecurityIncident` (puede devolver 0 filas si no hay un incidente real que dispare la regla — sirve para validar sintaxis):

```kql
SecurityIncident
| where Tags has "Revisado-Dia6"
| project IncidentNumber, Title, Severity, Status, Tags
```

**Evidencia que cierra el lab:**
- Automation rule visible en la lista de Automation, con Order=1 y la condición correcta.
- Playbook visible en Automation → Playbooks, con el trigger correcto.
- El rol Microsoft Sentinel Automation Contributor quedó asignado sobre el resource group (verificable en IAM) y el playbook deja de aparecer en gris.
- La query del Paso 5 corre sin error de sintaxis.

### 2.3 Día 7 — Workbooks, SOC optimization, roles y notificaciones (~85 min)

Este es el lab más largo, y también el que ataca directamente la **deuda de re-test pendiente desde el 9-ago** (P1 y P5 del quiz del Día 7, sobre roles y sobre la ruta de notificaciones — ver §2.4 si el tiempo aprieta).

1. **Workbook desde plantilla.** Threat management → Workbooks → Templates. Antes de guardar, lee `Required data types` y confirma que tienes esa tabla. Guarda, ábrelo, edita al menos un elemento.
2. **Workbook desde cero.** Add workbook → Edit. Bloque de texto + consulta con Data source = Logs, Resource type = Log Analytics, sobre `SecurityEvent`. Añade un parámetro TimeRange y confirma que las gráficas reaccionan.
3. **Auto refresh.** Actívalo a 5 minutos, cierra el workbook, reábrelo y **confirma que se desactivó solo** (comportamiento documentado, no un bug).
4. **SOC optimization.** Revisa qué recomendaciones salen para tu workspace (lo esperable en un workspace joven: cobertura y quizá similar organizations).
5. **Roles / IAM — el punto del re-test P1.** Portal de Azure → resource group del workspace → Access control (IAM) → Role assignments. Localiza los roles `Microsoft Sentinel *` y confirma en qué ámbito están asignados. **No cambies nada.** Esto es exactamente lo que P1 preguntaba: crear/eliminar workbooks exige un rol de Sentinel **más** Workbook Contributor sobre el resource group — confirma si tu asignación actual ya cumple esa combinación.
6. **Notificaciones — el punto del re-test P5.** Portal de Defender → Settings → **Endpoints → General** (NO la rama "Microsoft Defender XDR → Email notifications", esa es la de vulnerabilidades). Abre el asistente de notificaciones de incidentes hasta la pantalla de Recipients. Puedes cancelar sin crear la regla.
7. **Alert tuning.** Settings → Microsoft Defender XDR → Rules → Alert tuning. Lee las reglas integradas que trae tu tenant e identifica qué ruido concreto suprime al menos una.

**Evidencia que cierra el lab:**
- Workbook de plantilla guardado y visible en "My workbooks".
- Workbook desde cero renderiza datos reales al correr la query (anota qué mostró).
- Confirmado que el auto refresh se apaga solo al reabrir.
- Al menos 1 recomendación de SOC optimization anotada.
- **Confirmación explícita del rol necesario para workbooks** (cierra P1).
- **Confirmación explícita de que la ruta de notificaciones de incidentes es Settings → Endpoints → General** (cierra P5).

### 2.4 Si el tiempo aprieta: qué recortar primero

El Bloque A completo son ~3h10min, por encima del presupuesto de 2-3h. Si no alcanza el sábado, el orden de recorte es:

1. **Recorta primero el Día 7 Paso 2** (workbook desde cero) — es el más largo (~20 min) y el que menos aporta: la deuda medida en el tracker sobre el Día 7 nunca fue "no sabe construir un workbook", fue **"no sabe qué rol adicional hace falta" y "en qué rama del portal viven las notificaciones"** (Pasos 5 y 6). No sacrifiques esos dos.
2. Si aún sobra tiempo por recortar, el Día 4 Paso 4 (duplicar una anomaly rule) es opcional — ya quedó explicado en la lección con el razonamiento completo, el lab solo confirma el flujo visual.
3. **Nunca recortes el Paso 3 del Día 6** (resolver el permiso del playbook en gris): es la única parte de todo el Bloque A que reproduce en vivo un error real de RBAC, y ese es justo el tipo de fallo que ya costó puntos dos veces en este curso.

---

## 3. Bloque B — Defender for Endpoint / Portal unificado (Días 5, 8, 9)

**Duración real estimada: ~2h40min** — cabe holgado en un bloque grande de sábado.

**Requisito único:** tu trial M365 E5 personal, portal `security.microsoft.com`. Si algún dispositivo no está onboardeado o alguna función (Cases, Custom data collection) no aparece en tu tenant por ser prerelease o por limitación del trial, la propia lección ya trae el módulo de Microsoft Learn de respaldo — úsalo sin perder tiempo intentando forzar algo que el tenant no expone.

### 3.1 Día 5 — ASR rules, Advanced features, Device groups (~50 min)

1. **ASR rules.** Settings → Endpoints → Attack surface reduction rules. Revisa las 16 reglas, identifica las 3 "Standard protection rules", confirma que la regla de LSASS **no** ofrece Warn en su selector.
2. **Advanced features.** Settings → Endpoints → Advanced features. Localiza Tamper protection, EDR in block mode, Live response (+ scripts sin firmar), Custom network indicators, Automated Investigation. Anota cuáles están activas por defecto.
3. **Device group.** Settings → Endpoints → Device groups → Add device group. Regla simple por nombre/tag, automation level "Full – remediate threats automatically".
4. **Custom data collection.** Busca la función en el portal; si no está visible (prerelease), documenta la ausencia y lee "How custom data collection works" en la documentación oficial.

**Evidencia que cierra el lab:**
- Confirmado que LSASS no admite Warn (captura o nota del selector).
- Lista de qué advanced features están ON por defecto en el trial.
- Device group visible en la lista, con automation level asignado.
- Custom data collection: disponible y configurado, o ausencia documentada con la lectura de respaldo hecha.

Query opcional de verificación si ya tienes eventos ASR de sesiones anteriores del trial:

```kql
DeviceEvents
| where ActionType startswith "Asr"
| summarize count() by ActionType
| order by count_ desc
```

### 3.2 Día 8 — Manage incident pane y Case Management (~48 min)

1. **Manage incident pane.** Abre un incidente real (o uno de demo si el trial trae datos de ejemplo). Practica triage completo: cambia severidad, agrega tags, cambia status, añade un comentario, revisa el activity log.
2. **Explorar Cases.** Busca "Cases" en el menú del portal. Si tu tenant lo tiene disponible, entra y revisa la cola. Si no aparece (frecuente en tenants de laboratorio), documenta la limitación y repasa el flujo con las capturas de Microsoft Learn en vez de ejecutarlo en vivo.
3. **Si Cases está disponible:** crea un case de prueba (Priority = Medium), agrega una task con due date, vincula el incidente del Paso 1 desde Linked Objects → Incidents, añade un comentario con formato enriquecido.
4. **RBAC.** Revisa qué rol tiene tu cuenta y contrástalo contra la tabla de roles de case management de la lección (§9): ¿podrías crear un case? ¿personalizar sus estados?
5. **Límites de servicio.** Repaso mental sin necesidad de alcanzarlos: 100,000 cases/tenant, 500 GB adjuntos/tenant, 100 incidentes vinculados/case.

**Evidencia que cierra el lab:**
- Al menos un incidente triaged de punta a punta, con el activity log mostrando los cambios.
- Cases: caso de prueba creado con task + incidente vinculado, o ausencia documentada.
- Tu propio rol de RBAC identificado y contrastado contra la tabla de permisos.

### 3.3 Día 9 — Roles de MDE, Live response, Timeline, evidencia (~60 min)

1. **Roles.** Settings → Endpoints → Roles. Confirma que View data, Active remediation actions, Alerts investigation, Live response Basic y Live response Advanced son casillas independientes entre sí.
2. **Prerrequisitos de Live response.** Settings → Endpoints → Advanced features. Confirma visibilidad del toggle de Live response y anota si "servidores" y "scripts sin firmar" están activados por defecto.
3. **Timeline (si hay un dispositivo onboardeado).** Assets → Devices → abre un dispositivo → pestaña Timeline. Prueba el selector de rango de fechas, marca un evento con bandera, abre algún evento con técnica MITRE si aparece.
4. **Collect investigation package (si hay un dispositivo real).** Selecciónalo desde la barra de acciones, confírmalo, descarga el .zip cuando el Action center avise, y verifica que las carpetas coinciden con la tabla de la lección (Autoruns, Processes, Network connections, etc.).
5. **Si no hay dispositivo onboardeado:** completa las unidades 2-5 del módulo de Learn "Perform actions on a device using Microsoft Defender for Endpoint" (enlazado en la lección) como sustituto — simula el flujo completo con capturas reales.

**Evidencia que cierra el lab:**
- Confirmación de que los 5 permisos de RBAC son casillas independientes (cierra el punto RBAC de la sección 6 de la lección).
- Estado real (ON/OFF) de los toggles de Live response en el trial.
- Timeline explorado con al menos un evento marcado, o módulo de Learn completado como sustituto.
- Investigation package descargado y carpetas verificadas, o módulo de Learn completado como sustituto.

---

## 4. Después de los dos bloques

Cuando Bloques A y B queden marcados, la deuda de labs de los Días 4-9 llega a cero. Sigue pendiente por separado (no forma parte de esta guía):

- **Quiz del Día 9 + repaso acumulativo del Día 9** — no requieren tenant, se responden en cualquier momento.
- **Simulacro #2** — necesita su propio bloque de sábado, no cabe añadido a ninguno de los dos de arriba. Fecha a definir en el próximo reanclaje del calendario.

---

*Relacionado: [[PLAN_MAESTRO_MULTITRACK]] · [[TRACKER_TUTOR]] · [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] · [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] · [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] · [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] · [[Dia 08 - Incidentes Unificados y Case Management]] · [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]*
