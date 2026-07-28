---
title: Simulacro 01 — Dominio 1 (Manage a security operations environment) hasta Día 6
tipo: Simulacro / Mock Exam
fecha_creacion: 2026-07-24
tags: [sc-200, simulacro, mock-exam, dominio-1, sentinel, mde, quiz]
cobertura: "Días 1-6 del plan intensivo: tiers de datos, ingestión (AMA/DCR/WEF/Syslog/CEF/Azure Policy/TI/tablas custom), analytics rules (Scheduled/NRT/Fusion/Anomaly), MITRE coverage, MDE (ASR rules/advanced features/device groups/custom data collection), AIR, Attack Disruption, Automation rules, Playbooks"
relacionado: "[[GUIA_INTENSIVA_24_DIAS]], [[TRACKER_TUTOR]], [[Dia 01 - Arquitectura Sentinel y Tiers de Retencion]], [[Dia 02 - Ingestion 1 AMA DCR Windows Security Events y WEF]], [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]], [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]], [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]], [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]"
---

# 🧪 Simulacro 01 — Dominio 1 (hasta Día 6)

> [!info] Cómo usar este simulacro
> 24 preguntas, estilo examen real SC-200 (opción múltiple + 2 case studies con varias preguntas sobre el mismo escenario). Cubre exclusivamente lo que ya viste en los Días 1–6 del plan: tiers de datos, ingestión completa, analytics rules, cobertura MITRE, configuración avanzada de MDE, AIR, Attack Disruption, automation rules y playbooks — todo dentro del **Dominio 1: Manage a security operations environment (40–45% del examen real)**.
>
> **Recomendación de tiempo:** ~35-40 minutos sin consultar notas (el examen real da ~2-2.5 min/pregunta). Responde primero, revisa después. Las respuestas correctas y su explicación están **todas juntas al final**, dentro de un bloque plegable — no las mires hasta terminar.
> **Meta:** ≥18/24 (75%) para considerar el dominio 1 sólido hasta este punto.

---

## 📋 Case Study 1 — Contoso Ltd.

> [!quote] Escenario
> Contoso Ltd. administra Microsoft Sentinel sobre un único Log Analytics workspace centralizado, con el portal unificado de Defender. El entorno tiene las siguientes características:
>
> - Una subred de planta industrial con **180 servidores Windows Server** que **no tienen salida a Internet**, salvo un servidor de gestión `MGMT01` que sí tiene una ruta autorizada hacia Azure a través de un firewall interno.
> - **35 firewalls de próxima generación** que, según su ficha técnica, soportan exportación de logs en formato **CEF**.
> - Una obligación regulatoria de conservar los logs de firewall (tabla `CommonSecurityLog`) durante **7 años**, que el equipo de compliance solo consulta **una vez al año** durante la auditoría anual.
> - **60 suscripciones de Azure** agrupadas bajo un management group llamado `mg-contoso`: 45 de ellas ya existían antes de iniciar el proyecto de Sentinel, y 15 se crearán en los próximos meses conforme se completa una migración.
> - Dos automation rules activas sobre el trigger **"When incident is created"**: `AR-Sev` (Order = 1) baja automáticamente la severidad a **Low** en todo incidente generado por la analytics rule "Legacy Scanner Noise"; `AR-Escalate` (Order = 2) asigna el incidente al equipo Tier 2 **solo si la severidad es High o Critical**.

**P1.** Los 180 servidores de la planta industrial no pueden alcanzar Azure Monitor directamente. ¿Qué arquitectura de ingestión configura el equipo de Contoso?
A) Instalar Azure Monitor Agent (AMA) directamente en cada uno de los 180 servidores
B) Configurar Windows Event Forwarding con los 180 servidores como forwarders hacia `MGMT01` como colector, e instalar AMA + una DCR en `MGMT01` que lea el canal `ForwardedEvents`
C) Configurar el conector CEF vía AMA en cada uno de los 180 servidores
D) Usar la Logs Ingestion API con una tabla custom `_CL` para cada servidor

**P2.** Los 35 firewalls confirman soporte de exportación CEF. ¿Qué conector eligen y en qué tabla del workspace aterrizan los eventos ya estructurados en columnas con nombre (`DeviceVendor`, `SourceIP`, etc.)?
A) Syslog vía AMA → tabla `Syslog`
B) CEF vía AMA → tabla `CommonSecurityLog`
C) Windows Security Events via AMA → tabla `SecurityEvent`
D) Custom Logs API → tabla `Firewall_CL`

**P3.** Para minimizar el costo de conservar `CommonSecurityLog` los 7 años exigidos por la regulación, sabiendo que compliance solo consulta esos datos una vez al año, ¿qué configuran?
A) Extender la retención del Analytics tier a 7 años
B) Exportar los datos a una Storage Account de Azure
C) Configurar el Data lake tier con retención extendida a 7 años, consultando vía KQL jobs cuando llegue la auditoría
D) Crear una tabla custom `_CL` con retención personalizada de 7 años

**P4.** Contoso quiere que la diagnostic setting de Azure Activity hacia el workspace de Sentinel se aplique automáticamente a las 45 suscripciones existentes y a las 15 futuras, sin configurar cada una a mano. ¿Qué combinación de acciones logra esto?
A) Asignar la política integrada `DeployIfNotExists` con scope en `mg-contoso`; las 15 futuras quedan cubiertas automáticamente al crearse, pero las 45 existentes solo quedan marcadas como "non-compliant" hasta lanzar una remediation task
B) Asignar la política en cada una de las 60 suscripciones individualmente, ya que `DeployIfNotExists` no soporta scope de management group
C) Asignar la política con scope en `mg-contoso`; las 60 suscripciones (existentes y futuras) quedan corregidas automáticamente sin ninguna acción adicional
D) Configurar manualmente la diagnostic setting en las 45 existentes y confiar en que Azure Policy solo cubre automáticamente las que se creen después

**P5.** Se genera un incidente a partir de la analytics rule "Legacy Scanner Noise". Considerando el orden y la lógica de evaluación de `AR-Sev` y `AR-Escalate`, ¿el incidente termina asignado al equipo Tier 2?
A) Sí, porque ambas reglas evalúan la severidad original del incidente al momento de su creación, antes de cualquier cambio
B) No, porque `AR-Sev` corre primero (Order=1) y baja la severidad a Low; cuando `AR-Escalate` evalúa su condición, la severidad ya no es High/Critical
C) Sí, porque las automation rules del mismo trigger corren en paralelo y ambas ven el estado original simultáneamente
D) No, porque las automation rules con el mismo Order nunca pueden coexistir sobre el mismo incidente

---

## 📋 Case Study 2 — Fabrikam Inc.

> [!quote] Escenario
> Fabrikam Inc. usa Microsoft Defender for Endpoint con dos device groups configurados así:
>
> - **`Servers-Core`**: automation level **"Semi – require approval for core folders remediation"**.
> - **`Workstations-Sales`**: automation level **"Full – remediate threats automatically"**.
>
> Fabrikam está desplegando las 16 ASR rules siguiendo la estrategia recomendada: las **3 Standard protection rules** ya están en modo **Block**, y las **13 restantes** llevan **3 semanas en modo Audit** mientras el equipo revisa el impacto en producción.
>
> Durante un ataque de ransomware operado por humanos, en cuestión de segundos Defender XDR **contiene automáticamente** un dispositivo del grupo `Servers-Core` que estaba siendo usado para propagar el cifrado, y Defender for Identity **deshabilita** la cuenta de servicio asociada — sin que ningún analista intervenga. Media hora después, **AIR** investiga por separado un archivo malicioso distinto, encontrado en `C:\Windows\System32\Tasks\update.exe`, en ese mismo dispositivo.

**P6.** ¿Qué mecanismo explica que el dispositivo se haya contenido y la cuenta se haya deshabilitado en segundos, pese a que `Servers-Core` NO tiene el automation level en "Full"?
A) AIR ignoró el automation level configurado por un error de configuración
B) Automatic attack disruption actúa sobre el incidente completo con altísima confianza, y su activación es independiente del automation level del device group
C) Un playbook fue disparado manualmente por un analista de guardia
D) El automation level "Semi" en realidad solo restringe acciones sobre archivos, nunca sobre dispositivos o cuentas

**P7.** Sobre el archivo malicioso que AIR investiga en `C:\Windows\System32\Tasks\update.exe`, dado el automation level de `Servers-Core`, ¿qué ocurre?
A) Se remedia automáticamente sin aprobación, porque `Tasks` no es una carpeta del sistema operativo
B) Requiere aprobación manual en el Action Center, porque la ruta cae bajo `\windows\*` (core folder)
C) AIR no puede actuar porque Attack Disruption ya tomó control del dispositivo
D) Se rechaza automáticamente de inmediato, sin pasar por el Action Center

**P8.** El equipo de Fabrikam quiere revisar, antes de mover la regla "Block execution of potentially obfuscated scripts" de Audit a Block, cuántos eventos generó en las últimas 2 semanas y qué procesos los dispararon. ¿Qué consulta KQL usan?
A)
```kql
DeviceEvents
| where ActionType startswith "Asr"
| where TimeGenerated > ago(14d)
| summarize Eventos = count() by ActionType, InitiatingProcessFileName
```
B)
```kql
SecurityIncident
| where Title has "Asr"
| summarize count() by Severity
```
C)
```kql
Anomalies
| where AnomalyTemplateName has "obfuscated"
```
D)
```kql
ThreatIntelIndicators
| where ThreatType == "Obfuscation"
```

**P9.** ¿Cuáles de las 16 ASR rules están documentadas explícitamente como incompatibles con el modo Warn?
A) Block execution of potentially obfuscated scripts y Block JavaScript/VBScript from launching downloaded content
B) Block credential stealing from the Windows local security authority subsystem (LSASS) y Block Office applications from injecting code into other processes
C) Block abuse of exploited vulnerable signed drivers y Block persistence through WMI event subscription
D) Todas las 16 reglas soportan Warn sin excepción

---

## 📋 Preguntas independientes

**P10.** Una organización usa exclusivamente Defender XDR, sin conectar ningún workspace de Sentinel. ¿Cuál es la retención por defecto de los datos consultables en Advanced Hunting?
A) 90 días
B) 30 días
C) 180 días
D) 12 años

**P11.** ¿Qué agente reemplazó Microsoft de forma total para la recolección de logs, tras retirar el soporte del agente anterior en agosto de 2024?
A) El agente de Diagnostics extension
B) Azure Monitor Agent (AMA), reemplazando a Microsoft Monitoring Agent (MMA / agente OMS)
C) Telegraf agent
D) El Log Analytics agent, que sigue vigente en paralelo al AMA

**P12.** Un ingeniero configura una transformación KQL dentro de una Data Collection Rule para descartar eventos irrelevantes antes de que lleguen a la tabla `SecurityEvent`. ¿En qué momento del pipeline ocurre esta transformación, y qué implica para el costo?
A) Después de guardarse en la tabla, funcionando como una vista que oculta filas sin afectar el costo
B) Antes de guardarse (ingestion-time transformation): lo que la transformación descarta nunca se almacena ni se cobra
C) Solo aplica a tablas custom `_CL`, nunca a tablas estándar como `SecurityEvent`
D) Ocurre en el cliente (la VM), nunca en la nube

**P13.** Un servidor Linux emite mensajes syslog genéricos de aplicación, sin formato CEF. ¿Por qué esos eventos no pueden aprovechar columnas estructuradas como `SourceIP` o `DeviceVendor` una vez en Sentinel?
A) Porque Syslog usa un puerto distinto al de CEF y Sentinel no puede parsearlo
B) Porque un mensaje Syslog plano es texto libre sin una plantilla de campos fija, a diferencia de CEF que define una cabecera y extensiones clave=valor parseables
C) Porque el AMA no tiene soporte para distribuciones Linux
D) Porque Syslog requiere una licencia adicional de Sentinel para estructurarse

**P14.** Un analista necesita confirmar que los indicadores de compromiso (IPs, dominios, hashes) ingeridos vía el conector TAXII están llegando correctamente al workspace. ¿Qué tabla consulta hoy (2026), y por qué no debe usar `ThreatIntelligenceIndicator`?
A) `ThreatIntelligenceIndicator`, porque sigue siendo la tabla vigente y no ha cambiado
B) `ThreatIntelIndicators`, porque `ThreatIntelligenceIndicator` es la tabla legada que dejó de recibir datos nuevos el 31 de julio de 2025
C) `CommonSecurityLog`, porque los indicadores TI se normalizan igual que los eventos CEF
D) `ThreatIntelObjects`, porque ahí aterrizan tanto los IOCs como los objetos STIX ricos

**P15.** Una aplicación interna emite eventos JSON sin conector nativo. El equipo necesita ingerirlos con transformación en tiempo de ingestión y autenticación OAuth (no una clave compartida de todo el workspace). ¿Qué método y componentes usan?
A) HTTP Data Collector API (legado), con una clave compartida del workspace
B) El conector genérico REST de Sentinel, sin componentes adicionales
C) Logs Ingestion API basada en DCR: un Data Collection Endpoint (DCE), una tabla custom `_CL`, una DCR con transformación opcional, y una app de Microsoft Entra ID con el rol "Monitoring Metrics Publisher" sobre la DCR
D) Syslog vía AMA, redirigiendo el JSON como texto libre

**P16.** Un equipo SOC necesita detectar, con la menor latencia posible, un patrón simple sobre una sola tabla (`SigninLogs`) que se ingiere sin retrasos. ¿Qué tipo de analytics rule es más apropiado, y cuál es su límite operativo más citado en el examen?
A) Scheduled; sin límite de alertas por ejecución
B) NRT; corre cada minuto y puede generar como máximo 30 alertas por ejecución (29 individuales + 1 resumen)
C) Fusion; corre continuamente y no tiene límite de alertas
D) TI Map; depende de la frecuencia del feed de threat intelligence

**P17.** Fusion generó incidentes de un escenario que en la organización es ruido conocido (una herramienta legítima de administración remota). El equipo no quiere perder el resto de la cobertura de Fusion. ¿Qué hacen?
A) Editan directamente la lógica de correlación de Fusion para excluir ese patrón
B) Crean una exclusión de ese escenario específico dentro de la configuración de Fusion, sin apagar el motor completo
C) Deshabilitan Fusion por completo y migran esa detección a una regla Scheduled equivalente
D) Suben la severidad mínima de Fusion a Critical para filtrar el ruido

**P18.** Una anomaly rule llamada "Unusual Sign-In" lleva dos semanas poblando la tabla `Anomalies` con resultados de buena calidad, pero el SOC no ve ningún incidente relacionado en su cola de trabajo. ¿Cuál es la causa?
A) Las anomaly rules nunca generan incidentes ni alertas por sí solas; falta una regla Scheduled o NRT adicional que consulte `Anomalies` y decida cuándo generar la alerta
B) La regla está deshabilitada y hay que activarla
C) La severidad configurada es demasiado baja
D) Es un comportamiento anómalo del propio Sentinel que debe reportarse a soporte

**P19.** En el blade de cobertura MITRE ATT&CK de Sentinel, ¿qué diferencia exactamente a la vista "Simulated" de la vista "Active"?
A) Simulated solo muestra la cobertura aportada por Fusion
B) Simulated es una vista de demostración sin datos reales del workspace
C) Simulated suma, a las reglas activas y habilitadas, las plantillas de reglas sin activar, las hunting queries guardadas y las anomaly rules disponibles, mostrando la cobertura potencial si se activara todo
D) Simulated excluye del cálculo cualquier regla de tipo Anomaly

**P20.** Un servidor tiene un antivirus de terceros como protección principal, con Microsoft Defender Antivirus corriendo en modo pasivo (solo monitoreo, sin bloqueo). El SOC quiere que el motor EDR de Defender pueda bloquear y remediar artefactos maliciosos detectados después de su ejecución, sin reemplazar el antivirus de terceros. ¿Qué advanced feature activan?
A) Tamper protection
B) Live response
C) EDR in block mode
D) Custom network indicators

**P21.** Un atacante que ya obtuvo credenciales de administrador local intenta deshabilitar la protección en tiempo real de Microsoft Defender Antivirus vía PowerShell y Registro, para desplegar su payload sin ser detectado. ¿Qué advanced feature de MDE bloquea específicamente este intento, incluso con privilegios de administrador local?
A) Tamper protection
B) EDR in block mode
C) Web content filtering
D) Automated Investigation

**P22.** Un equipo de compliance necesita evidencia forense detallada de todo acceso a archivos dentro de la carpeta de una aplicación financiera propietaria, en 40 servidores específicos, sin aumentar el costo de ingesta del resto del entorno. Ya tienen Sentinel conectado. ¿Qué deben configurar primero, antes de poder crear la regla de custom data collection, y en qué tabla nueva verifican los resultados?
A) Primero una analytics rule Scheduled; los resultados aparecen en `SecurityAlert`
B) Primero una dynamic tag en Asset Rule Management que identifique esos 40 servidores; los resultados aparecen en `DeviceCustomFileEvents`
C) Primero un playbook que etiquete los servidores; los resultados aparecen en `DeviceFileEvents`
D) No se necesita configuración previa: la regla se puede crear apuntando directo a los 40 nombres de dispositivo

**P23.** Un SOC quiere que, automáticamente, cada incidente creado con el tag "VIP" se asigne al equipo Tier 2 y suba a severidad High, sin ninguna acción externa (sin enviar notificaciones, sin llamar APIs de terceros). ¿Qué construyen?
A) Un playbook con trigger "Microsoft Sentinel incident" que haga ambos cambios
B) Una automation rule sola, sin playbook: las acciones de asignar owner y cambiar severidad son nativas de la automation rule
C) Una custom detection rule en Advanced Hunting
D) Un workbook con una alerta configurada

**P24.** Un analista con el rol "Sentinel Contributor" crea una automation rule y agrega la acción "Run playbook", pero el playbook aparece en gris (no seleccionable). ¿Cuál es la causa más probable y cómo se resuelve?
A) El playbook necesita el rol "Microsoft Sentinel Reader" sobre la suscripción completa
B) Falta que la cuenta de servicio de Microsoft Sentinel tenga el rol "Microsoft Sentinel Automation Contributor" sobre el resource group donde vive el playbook; se concede desde "Manage playbook permissions", lo cual requiere permisos Owner sobre ese resource group
C) El playbook debe reconfigurarse como Logic App Standard en vez de Consumption
D) Automation rules solo permiten ejecutar un playbook por suscripción, y ya hay uno asignado

---

## ✅ Respuestas y explicaciones

> [!note]- Ver respuestas completas (spoiler — no mires antes de terminar)
>
> **Case Study 1 — Contoso**
> - **P1 — B.** Sin conectividad directa, AMA en cada uno de los 180 servidores no serviría de nada. WEF centraliza los eventos en `MGMT01` (el único con salida autorizada) vía forwarders, y solo ahí se instala AMA + una DCR que lee el canal `ForwardedEvents` (no `Security`).
> - **P2 — B.** El fabricante confirma soporte CEF, así que el conector correcto es CEF vía AMA, que parsea el mensaje en columnas propias dentro de `CommonSecurityLog` (a diferencia de Syslog plano, que queda como texto libre en la tabla `Syslog`).
> - **P3 — C.** "Retener años, consulta ocasional, minimizar costo" es el caso de uso canónico del Data lake tier (hasta 12 años, consulta vía KQL jobs). Exportar a Storage Account (B) pierde la consulta KQL nativa; extender Analytics (A) es la opción cara.
> - **P4 — A.** `DeployIfNotExists` con scope en el management group cubre automáticamente los recursos NUEVOS desde su creación, pero los recursos que ya existían antes de la asignación solo quedan marcados "non-compliant" — se necesita lanzar una remediation task manual para corregirlos retroactivamente.
> - **P5 — B.** Las automation rules del mismo trigger corren secuencialmente según su Order, y cada regla evalúa el **estado actual** del incidente después de que las reglas previas ya actuaron. `AR-Sev` (Order=1) baja la severidad a Low antes de que `AR-Escalate` (Order=2) evalúe su condición — por lo tanto la condición de `AR-Escalate` (severidad High/Critical) ya no se cumple.
>
> **Case Study 2 — Fabrikam**
> - **P6 — B.** Automatic attack disruption evalúa el incidente completo con altísima confianza (correlación multi-producto) y actúa sin importar el automation level configurado en el device group — ese automation level solo controla a AIR, no a Attack Disruption.
> - **P7 — B.** La ruta `C:\Windows\System32\Tasks\` cae bajo `\windows\*`, la definición exacta de "core folder" para el nivel "Semi – require approval for core folders remediation". Por eso requiere aprobación manual en el Action Center, sin importar que el ataque completo ya haya sido contenido por Attack Disruption (son mecanismos independientes).
> - **P8 — A.** Los eventos de reglas ASR (en Audit o Block) quedan en `DeviceEvents` con `ActionType` que empieza con el prefijo `Asr`; agrupar por `ActionType` e `InitiatingProcessFileName` muestra exactamente qué procesos disparan la regla y con qué frecuencia, antes de decidir mover a Block.
> - **P9 — B.** LSASS credential theft y Office code injection into other processes son las dos únicas reglas documentadas explícitamente como incompatibles con el modo Warn — solo admiten Audit o Block.
>
> **Preguntas independientes**
> - **P10 — B.** 30 días es la retención por defecto de Advanced Hunting cuando el tenant usa Defender XDR sin un workspace de Sentinel conectado.
> - **P11 — B.** AMA es el agente único y actual de Microsoft; MMA (también llamado agente OMS/Log Analytics agent) fue retirado en agosto de 2024. Diagnostics extension y Telegraf no son reemplazos directos.
> - **P12 — B.** Las transformaciones de DCR son ingestion-time: se ejecutan en el pipeline de la nube antes de escribir en la tabla. Lo que se descarta nunca se almacena ni se cobra, y esto aplica tanto a tablas estándar como a tablas custom.
> - **P13 — B.** Syslog genérico es texto libre sin estructura fija de campos; CEF define una cabecera obligatoria más extensiones en pares clave=valor, lo que permite parsear columnas con nombre como `SourceIP` o `DeviceVendor`.
> - **P14 — B.** `ThreatIntelIndicators` es la tabla vigente para IOCs desde abril de 2025. La tabla legada `ThreatIntelligenceIndicator` (singular) dejó de recibir datos nuevos el 31 de julio de 2025. `ThreatIntelObjects` es para objetos STIX no-indicador (actores, malware, relaciones), no para IOCs simples.
> - **P15 — C.** Es el caso de uso exacto de la Logs Ingestion API basada en DCR: DCE como endpoint HTTP, tabla `_CL`, DCR con transformación opcional, y autenticación OAuth vía una app de Entra ID con el rol Monitoring Metrics Publisher sobre la DCR. El método legado (A) usa una clave compartida de todo el workspace y ya no es el camino recomendado.
> - **P16 — B.** Baja latencia + consulta simple sobre una sola tabla sin retrasos de ingestión es el terreno de NRT: corre cada minuto, con el límite de 30 alertas por ejecución (29 individuales + 1 resumen) como su restricción más citada.
> - **P17 — B.** Fusion no se edita directamente en su lógica de correlación, pero sí soporta exclusiones a nivel de escenario específico, sin apagar el resto del motor.
> - **P18 — A.** Las anomaly rules solo pueblan la tabla `Anomalies`; nunca generan alertas ni incidentes por sí mismas, sin importar cuánto tiempo lleven corriendo ni la calidad de sus resultados. Se necesita una regla adicional (Scheduled o NRT) que las consuma.
> - **P19 — C.** Active = solo lo que ya corre habilitado en el workspace. Simulated = Active + templates de reglas sin activar + hunting queries guardadas + anomaly rules disponibles, para mostrar el potencial de cobertura si se activara todo.
> - **P20 — C.** EDR in block mode existe exactamente para este escenario: antivirus de terceros como protección principal, Defender Antivirus en modo pasivo, y necesidad de que el motor EDR bloquee/remedie post-ejecución sin reemplazar el AV principal.
> - **P21 — A.** Tamper protection bloquea cambios a configuraciones críticas de seguridad de Defender Antivirus incluso con privilegios de administrador local o vía Registro/PowerShell/GPO — es la defensa contra el intento típico de "apagar el antivirus" tras comprometer una cuenta admin.
> - **P22 — B.** Custom data collection exige, como prerrequisito obligatorio, una dynamic tag configurada primero en Asset Rule Management para targetear los dispositivos; los eventos de acceso a archivos aterrizan en la tabla nueva `DeviceCustomFileEvents` (distinta de la estándar `DeviceFileEvents`).
> - **P23 — B.** Cambios internos del incidente (asignar owner, cambiar severidad, agregar tag, cerrar) son acciones nativas de una automation rule; no requieren un playbook, que se reserva para acciones externas más complejas (notificar, llamar APIs, aislar dispositivos).
> - **P24 — B.** El playbook necesita el rol Microsoft Sentinel Automation Contributor sobre el resource group donde vive (no sobre la suscripción ni sobre el playbook individual). Se concede desde el enlace "Manage playbook permissions" en el propio wizard de la automation rule, y quien lo otorgue necesita el rol Owner sobre ese resource group.

---

*Simulacro creado el 2026-07-24 · Cobertura: Días 1-6 del [[GUIA_INTENSIVA_24_DIAS]] · Dominio 1 — Manage a security operations environment (40-45%) · Verificado contra Microsoft Learn (docs actualizados jun-jul 2026) tomando como base el contenido ya validado en las lecciones diarias correspondientes.*
