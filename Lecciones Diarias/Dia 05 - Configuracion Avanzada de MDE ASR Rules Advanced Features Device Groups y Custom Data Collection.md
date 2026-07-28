---
tags: [sc-200, mde, defender-for-endpoint, asr-rules, device-groups, advanced-features, custom-data-collection, automation-levels, leccion-diaria]
dia: 5
fecha: 2026-07-18
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
estado: ✅ Completada
cover: ""
---

# Lección Día 5 — Configuración avanzada de MDE: ASR rules, advanced features, device groups y custom data collection

> [!info] Contexto
> Día 5 del plan de [[GUIA_INTENSIVA_24_DIAS]] (Dominio 1 — Manage a security operations environment, 40–45% del examen). Retomamos hoy 18 de julio porque es el siguiente tema sin completar en el calendario reanclado (el Día 4 quedó con la lección impartida pero el quiz aún pendiente de que lo respondas — queda anotado abajo). Hasta ahora vimos cómo llega la telemetría a Sentinel y cómo Sentinel detecta amenazas sobre esos datos. Hoy cambiamos de plataforma: **Microsoft Defender for Endpoint (MDE)**, el producto que protege y vigila directamente los dispositivos (Windows, Linux, macOS, móviles), y su configuración avanzada — que es justo lo que un analista SOC necesita dominar antes de poder responder incidentes de endpoint (que veremos en la Fase 2 del plan). Cubrimos 4 huecos marcados como 🟡/❌ en la guía: **ASR rules**, **advanced features**, **device groups + automation levels**, y **custom data collection** (tema nuevo).
>
> ⚠️ **Hallazgo crítico de hoy, verificado en Microsoft Learn:** la documentación oficial de "Automation levels" (actualizada el 2 de julio de 2026) anuncia que **a partir del 1 de septiembre de 2026, AIR (Automated Investigation and Response) dejará de existir como experiencia de investigación separada** y no se podrá activar manualmente — sus capacidades quedan absorbidas dentro de la protección antivirus por defecto. Tu examen está agendado para el 29 de agosto (antes del cambio), así que probablemente todavía te pregunten sobre AIR con el modelo actual que enseño hoy. Pero es un dato que **no está en tu guía del vault** y que debes tener presente para el Día 6 (AIR vs Attack Disruption) — lo marco también en el `TRACKER_TUTOR.md`.

## 📖 Lectura

### 1. Attack Surface Reduction (ASR) rules

Una **ASR rule** (regla de reducción de superficie de ataque) es una configuración de **Microsoft Defender Antivirus** — no de MDE por sí solo, aunque MDE es quien te da la consola centralizada para desplegarlas, reportarlas y generar alertas a partir de ellas — que bloquea o audita **comportamientos concretos de software** que los atacantes explotan con frecuencia, incluso cuando el archivo que los ejecuta no está catalogado todavía como malware. La idea central: en vez de detectar "este archivo es malo" (que es lo que hace un antivirus tradicional por firma), ASR detecta "este comportamiento es sospechoso sin importar quién lo haga" — por ejemplo, "Word está intentando lanzar un proceso hijo" o "un script se está ejecutando ofuscado". Esto es exactamente lo que en el examen llaman **reducir la superficie de ataque**: cerrar los caminos que el malware usa típicamente, antes de que el malware específico exista.

Existen actualmente **16 reglas ASR**, agrupadas en dos categorías:
- **Standard protection rules** (3 reglas): Microsoft las recomienda activar en **Block** de inmediato porque su impacto en la productividad del usuario es mínimo. Son: *Block abuse of exploited vulnerable signed drivers*, *Block credential stealing from the Windows local security authority subsystem* (protege el proceso LSASS, el que autentica inicios de sesión en Windows — el objetivo típico de herramientas como Mimikatz para robar hashes de credenciales), y *Block persistence through WMI event subscription*.
- **Other ASR rules** (13 reglas): requieren más prueba porque pueden interferir con flujos de trabajo legítimos. Incluyen: bloquear que Office cree procesos hijos, bloquear contenido ejecutable en email, bloquear ejecutables sin reputación/antigüedad/lista de confianza suficiente, bloquear scripts ofuscados, bloquear JavaScript/VBScript que lance contenido descargado, bloquear que Office cree o inyecte código ejecutable, bloquear procesos desde PsExec/WMI, bloquear reinicio en modo seguro, bloquear ejecutables sin firmar desde USB, bloquear herramientas del sistema copiadas/suplantadas, bloquear creación de web shells en servidores Exchange, bloquear llamadas Win32 API desde macros de Office, y la regla de **protección avanzada contra ransomware** (usa heurísticas de nube y cliente para bloquear archivos que "parecen" ransomware aunque no tengan mala reputación confirmada todavía).

**Cada regla se configura en uno de 4 estados** (el examen los pregunta constantemente):
- **Not configured / Off (0)** — la regla no actúa.
- **Audit (2)** — la regla NO bloquea nada ni molesta al usuario, pero registra en el log cada vez que el comportamiento habría sido bloqueado. Es el estado con el que **siempre debes empezar** un despliegue nuevo, durante 2-4 semanas, para medir el impacto real sin romper nada en producción.
- **Warn (6)** — bloquea la acción pero le muestra al usuario una notificación tipo "toast" con un botón para desbloquear voluntariamente ("Unblock"). Es un punto intermedio educativo antes de forzar el bloqueo total.
- **Block (1)** — bloquea la acción sin excepción posible por parte del usuario (solo un administrador puede añadir una exclusión).

**Dato para el examen que suele confundirse:** no todas las reglas soportan **Warn**. Dos reglas están documentadas explícitamente como incompatibles con Warn: *Block credential stealing from the Windows local security authority subsystem* (LSASS) y *Block Office applications from injecting code into other processes*. Si un escenario de examen pide "aplica Warn a la regla de LSASS", la respuesta correcta es que **no es posible** — solo puedes elegir entre Audit o Block para esa regla en particular.

**Despliegue:** las ASR rules no se activan directamente desde MDE de forma aislada — se despliegan a través de un mecanismo de gestión: **Intune** (o las mismas políticas de seguridad de endpoint que ves en el portal unificado de Defender, que internamente usan el motor de Intune), **Microsoft Configuration Manager**, **cualquier proveedor MDM (Mobile Device Management) vía la Policy CSP (Configuration Service Provider)**, o **Group Policy centralizada** para dispositivos no administrados por Intune. La estrategia recomendada por Microsoft es exactamente la del ejercicio de hoy: **Audit en las 16 reglas simultáneamente durante 2-4 semanas → revisar el reporte de impacto → mover a Block regla por regla, empezando por las de menor disrupción** (las 3 "standard protection" primero).

**Auditar el impacto con KQL:** cada evento de una regla ASR (tanto en Audit como en Block) queda registrado con un `ActionType` que empieza con el prefijo `Asr` (por ejemplo `AsrLsassCredentialTheftAudited` o `AsrOfficeChildProcessBlocked`) dentro de la tabla `DeviceEvents` de Advanced Hunting. El identificador de la regla concreta que disparó el evento vive en el campo `AdditionalFields`, como GUID.

### 2. Advanced features

Las **advanced features** (características avanzadas) son un conjunto de interruptores de configuración a nivel de tenant en MDE (**Settings → Endpoints → Advanced features** en el portal de Defender) que activan o desactivan capacidades completas del producto — no son reglas de comportamiento como ASR, sino funciones de plataforma. Las que más pregunta el examen:

- **Tamper protection (protección contra manipulación).** Bloquea que se cambien configuraciones críticas de seguridad de Microsoft Defender Antivirus (desactivar protección en tiempo real, eliminar actualizaciones de firmas, deshabilitar el motor) **incluso con privilegios de administrador local o vía Registro/PowerShell/GPO**. Es la defensa contra el paso típico de un atacante que, tras comprometer una cuenta admin, intenta "apagar el antivirus" antes de desplegar su payload. Se gestiona de forma centralizada desde MDE cuando está activada esta advanced feature (en vez de configurarse dispositivo por dispositivo).
- **EDR in block mode.** Resuelve un escenario específico: tienes **otro antivirus de terceros como protección principal** (Defender Antivirus corre en **modo pasivo**, solo monitoreando sin bloquear). Normalmente en modo pasivo Defender no puede bloquear nada. Al activar "EDR in block mode", el motor EDR (Endpoint Detection and Response — el componente que analiza comportamiento y telemetría, no firmas) SÍ puede bloquear y remediar artefactos maliciosos detectados **después de que ya se ejecutaron** (post-breach), aunque el antivirus principal del dispositivo sea de otro fabricante. Es una capa de seguridad adicional, no un reemplazo del AV de terceros.
- **Live response.** Habilita la consola de respuesta remota en vivo (que veremos en detalle el Día 9) sobre los dispositivos onboardeados. Dentro de esta misma advanced feature hay un sub-interruptor importante: **permitir ejecutar scripts sin firmar** durante una sesión de live response — está desactivado por defecto y debe activarse explícitamente si tu SOC necesita correr scripts propios de investigación/remediación.
- **Custom network indicators.** Permite crear indicadores personalizados de IP, dominio o URL (allow/block) que MDE aplica a nivel de red en los endpoints — es el mecanismo detrás de "bloquear esta IP de C2 en todos los dispositivos onboardeados ya mismo", sin esperar a una firma de antivirus.
- Otras que conviene reconocer de nombre (menor probabilidad de pregunta profunda): **Automated Investigation** (el interruptor maestro de AIR, relevante hoy — ver advertencia arriba sobre su retiro), **Web content filtering** (bloquea categorías de sitios web a nivel de red, requiere licencia y funciona vía el mismo motor de indicadores de red), y **Preview features** (activa capacidades en prerelease antes de disponibilidad general — como el custom data collection que vemos abajo).

### 3. Device groups: RBAC y automation levels

Un **device group** (grupo de dispositivos) en MDE es una agrupación lógica de endpoints, construida normalmente con **reglas basadas en atributos** (dominio, rango de IP, tag, nombre del dispositivo) en vez de asignación manual uno por uno. Sirven para dos cosas distintas que el examen le encanta separar:

1. **RBAC (Role-Based Access Control, control de acceso basado en roles):** puedes asociar un device group con un **grupo de Microsoft Entra ID** específico, de forma que los analistas que pertenecen a ese grupo de Entra **solo vean alertas, incidentes y datos de esos dispositivos** — por ejemplo, el equipo de SOC de la filial de LATAM solo ve los servidores de LATAM, no los de EMEA. Esto es puramente sobre **visibilidad y permisos**.
2. **Automation level:** cada device group tiene asignado un nivel de automatización que determina qué tan agresivamente actúa **AIR (Automated Investigation and Response)** cuando investiga evidencia maliciosa en esos dispositivos. Los niveles, de más a menos automático:
   - **Full – remediate threats automatically:** las acciones de remediación se ejecutan solas sobre lo que se determina malicioso, sin esperar aprobación. Es el nivel **recomendado por Microsoft** (dato del examen: los datos de telemetría de Microsoft muestran que los tenants con Full automation remueven un 40% más de malware de alta confianza que los que usan niveles inferiores) y es el **default para tenants creados desde el 16 de agosto de 2020** en adelante sin device groups definidos.
   - **Semi – require approval for all folders:** toda acción de remediación queda pendiente de aprobación manual en el Action Center, sin excepción de carpeta.
   - **Semi – require approval for core folders remediation:** solo requiere aprobación si el archivo/ejecutable está en una carpeta del sistema operativo (`\windows\*`); fuera de esas carpetas, remedia automáticamente.
   - **Semi – require approval for non-temp folders remediation:** el criterio se invierte — remedia automáticamente solo en carpetas temporales conocidas (`\temp\*`, `\downloads\*`, etc.); todo lo demás requiere aprobación.
   - **No automated response:** AIR no corre en absoluto sobre esos dispositivos. **No recomendado** — reduce la postura de seguridad, aunque otras protecciones (antivirus en tiempo real) siguen activas.

   Las acciones pendientes de aprobación (nivel Semi) **expiran a los 7 días** — si nadie las aprueba ni rechaza, se tratan como rechazadas automáticamente.

### 4. Custom data collection (tema nuevo, en prerelease)

**Custom data collection** es una capacidad nueva de MDE (documentada como **prerelease** — puede cambiar antes de su disponibilidad general, así que en el examen probablemente aparezca solo a nivel conceptual) que resuelve un problema concreto: la telemetría por defecto de MDE es enorme pero **genérica**; a veces un SOC necesita visibilidad **muy específica** (por ejemplo, "todas las ejecuciones de PowerShell en las workstations administrativas" o "todo acceso a archivos en la carpeta de una app financiera propietaria") sin pagar el costo y el ruido de ingerir absolutamente todo.

Cómo funciona: defines **reglas de recolección** en el portal de Defender con filtros específicos sobre propiedades de evento (rutas de carpeta, nombres de proceso, conexiones de red). Esas reglas se dirigen a dispositivos usando **dynamic tags** (etiquetas dinámicas que se actualizan solas cuando cambian los atributos del dispositivo, a diferencia de las tags manuales que hay que mantener a mano) — las dynamic tags se configuran primero en **Asset Rule Management**, es un **prerequisito obligatorio**: no puedes crear una regla de custom data collection sin haber definido antes la dynamic tag que la va a targetear. Las reglas tardan entre **20 minutos y 1 hora** en desplegarse a los dispositivos targeteados.

Los eventos capturados van a **5 tablas nuevas y separadas** de las tablas estándar (no reemplazan ni modifican la telemetría por defecto, se suman a ella): `DeviceCustomProcessEvents`, `DeviceCustomImageLoadEvents` (carga de DLLs), `DeviceCustomFileEvents`, `DeviceCustomNetworkEvents` y `DeviceCustomScriptEvents`. Un requisito clave para el examen: **necesitas un workspace de Sentinel conectado** — sin Sentinel no puedes crear ni usar reglas de custom data collection, porque ahí es donde se consultan los datos. Y hay un **límite de 75,000 eventos por regla por dispositivo cada 24 horas**: al llegar al tope, esa regla concreta deja de recolectar en ese dispositivo hasta que la ventana rotativa de 24h se reinicia (las demás reglas del dispositivo siguen funcionando con normalidad) — la solución si te topas con el límite es afinar los filtros de la regla para que sea más específica.

📝 Notas del vault relacionadas (revisar críticamente, no como fuente): [[03_Semana3_Defender_XDR]] §1 (features básicas de MDE), [[Modulo_2_Defender_for_Endpoint]]. Ninguna de las dos cubre hoy los 4 temas completos — están marcados como 🟡/❌ en el mapeo de [[GUIA_INTENSIVA_24_DIAS]], que sigue siendo correcto en ese punto.

## 💡 Ejemplos concretos

**Ejemplo 1 — Elegir el modo correcto de una ASR rule (tipo examen)**

*Escenario:* "El SOC (Security Operations Center) de Contoso quiere desplegar la regla *Block credential stealing from the Windows local security authority subsystem* con una notificación al usuario antes de bloquear la acción, para minimizar quejas de soporte. ¿Es posible?"

*Razonamiento:* No. Esta regla protege el acceso a memoria de LSASS y está documentada explícitamente como **incompatible con el modo Warn** — solo admite Audit o Block. Además, produce un volumen alto de eventos de auditoría que en su mayoría son ruido seguro de ignorar; Microsoft recomienda empezar directamente en un piloto pequeño de dispositivos en Block, en vez de gastar semanas en Audit para esta regla en particular.

```kql
// Auditar impacto de la regla LSASS antes/durante el despliegue (Día 5)
DeviceEvents
| where ActionType in ("AsrLsassCredentialTheftAudited", "AsrLsassCredentialTheftBlocked")
| summarize Eventos = count(), Dispositivos = dcount(DeviceName), Procesos = make_set(InitiatingProcessFileName, 10)
    by ActionType
| order by Eventos desc
```

**Ejemplo 2 — Automation level y el flujo de AIR (tipo examen)**

*Escenario:* "Un device group llamado 'Servidores-Finanzas' tiene el nivel de automatización 'Semi – require approval for core folders remediation'. AIR investiga un archivo malicioso ubicado en `C:\Windows\Temp\payload.exe` y otro en `C:\ProgramData\App\update.exe`, ambos con veredicto Malicious. ¿Qué ocurre con cada uno?"

*Razonamiento:* la clave de este nivel es que "core folders" = directorios del sistema operativo, específicamente rutas bajo `\windows\*`. El archivo en `C:\Windows\Temp\` cae dentro de esa definición → **requiere aprobación manual** en el Action Center. El archivo en `C:\ProgramData\App\` NO está en una core folder → **se remedia automáticamente** sin esperar aprobación. Es un error común asumir que "Temp" siempre implica remediación automática (eso aplica al nivel "non-temp folders", un nivel distinto) — aquí lo que decide es si la ruta cae bajo `\windows\*`, sin importar si contiene la palabra "Temp".

**Ejemplo 3 — Custom data collection para hunting dirigido (tipo examen)**

*Escenario:* "El equipo de compliance necesita evidencia forense detallada de todo acceso a archivos dentro de la carpeta de una aplicación financiera propietaria en 40 servidores específicos, sin aumentar el costo de ingesta del resto del entorno. Tienen Sentinel conectado. ¿Qué configuran y en qué orden?"

*Razonamiento:* 1) primero crear/verificar una **dynamic tag** en Asset Rule Management que identifique esos 40 servidores (por ejemplo, por nombre o dominio); 2) crear una **regla de custom data collection** con un filtro de ruta de carpeta apuntando a la app financiera, dirigida a esa dynamic tag; 3) seleccionar el workspace de Sentinel de destino; 4) esperar el despliegue (20 min–1h) y consultar la tabla `DeviceCustomFileEvents`. Content search o Purview Audit (temas del Día 13) NO aplican aquí porque el escenario es sobre archivos en un endpoint, no sobre operaciones de M365/SharePoint.

```kql
// Verificar que la regla de custom data collection está capturando eventos (Día 5)
DeviceCustomFileEvents
| where TimeGenerated > ago(1h)
| summarize Eventos = count(), UltimoEvento = max(TimeGenerated) by DeviceName, RuleName
| order by Eventos desc
```

## 🎥 Videos

1. **"Microsoft Defender ASR Rules Explained – Strengthen Endpoint Security with Intune"** — [YouTube](https://www.youtube.com/watch?v=M5oYvTLDmOg), publicado en febrero de 2025. Cubre el despliegue práctico de ASR rules vía Intune (audit → warn/block), que es exactamente el flujo que el examen espera que domines. Duración aproximada 15-20 min según el listado; no es de 2026 pero el mecanismo de despliegue de ASR no ha cambiado.
2. **"Preparing for SC-200: Manage a security operations environment (Part 1 of 4)"** — [Microsoft Learn Shows](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/preparing-for-sc-200-manage-a-security-operations-environment). Nota de honestidad: este video usa los **pesos de dominio viejos** (4 dominios de 15-30% cada uno, ya no vigentes — no te confundas, los pesos correctos son los 3 dominios 40-45/35-40/20-25 de tu guía), pero la parte de configuración de MDE (device groups, ASR, automation levels) sigue siendo conceptualmente correcta y vale la pena verlo solo por ese contenido.

No encontré un video reciente y bueno específico sobre **custom data collection** (es una función en prerelease de 2026, casi no hay contenido en YouTube todavía) — para eso usa directamente la [documentación oficial](https://learn.microsoft.com/en-us/defender-endpoint/custom-data-collection), que es la fuente que usé para esta lección.

## 🧪 Ejercicio práctico

> [!info] Requisito
> Usa tu trial M365 E5 / portal de Defender (`security.microsoft.com`). Si tu tenant universitario de La Salle tiene el portal unificado limitado (como ya detectamos en sesiones anteriores), haz este ejercicio en el trial E5 personal, NO en el tenant universitario.

- [ ] **Paso 1 — Explorar ASR rules.** Ve a **Settings → Endpoints → Attack surface reduction rules** (o **Endpoint security → Attack surface reduction** si usas el flujo tipo Intune). Revisa las 16 reglas, identifica las 3 "Standard protection rules", y confirma que la regla de LSASS no ofrece la opción Warn en su selector de modo.
- [ ] **Paso 2 — Explorar Advanced features.** Ve a **Settings → Endpoints → Advanced features**. Localiza Tamper protection, EDR in block mode, Live response (y su sub-opción de scripts sin firmar), Custom network indicators y Automated Investigation. Anota cuáles están activadas por defecto en tu trial.
- [ ] **Paso 3 — Crear un device group.** Ve a **Settings → Endpoints → Device groups → Add device group**. Crea uno de prueba con una regla simple (por nombre o tag), asígnale automation level "Full – remediate threats automatically", y dejarlo sin asociar a un grupo de Entra específico si no tienes uno de prueba disponible (documenta el paso, no hace falta un grupo real).
- [ ] **Paso 4 — Buscar Custom data collection.** Ve a **Settings → Endpoints → Custom data collection** (o busca "custom data collection" en el buscador del portal). Si tu tenant aún no tiene la función visible (es prerelease), documenta que no está disponible y en su lugar lee la sección "How custom data collection works" de la [documentación oficial](https://learn.microsoft.com/en-us/defender-endpoint/custom-data-collection) para reforzar el flujo de 5 pasos.
- [ ] **Paso 5 (teoría complementaria) —** repasa el lab oficial [Lab 4 Ex1 — Deploy Defender for Endpoint](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_04_Lab1_Ex01_Deploy_Defender_Endpoint.html) para ver device groups y automation levels en el flujo completo de onboarding.
- [ ] **Paso 6 —** responde el quiz de hoy y, si tienes tiempo, retoma el quiz pendiente del Día 4.

## ✅ Quiz del día

**P1.** Tu SOC quiere desplegar las 16 ASR rules por primera vez en un entorno de 5,000 dispositivos. ¿Cuál es la estrategia recomendada?
A) Activar todas en Audit durante 2-4 semanas, revisar el impacto, y mover a Block regla por regla empezando por las de menor disrupción · B) Activar todas en Block de inmediato para máxima protección · C) Activar solo la regla de ransomware y dejar el resto en Off · D) Activar todas en Warn permanentemente

**P2.** Un analista intenta configurar la regla *Block Office applications from injecting code into other processes* en modo Warn. ¿Qué ocurre?
A) Se configura sin problema · B) Se configura pero nunca notifica al usuario · C) No es posible: esta regla no soporta el modo Warn, solo Audit o Block · D) Requiere licencia adicional para Warn

**P3.** Un servidor corre un antivirus de terceros como protección principal (Defender Antivirus en modo pasivo). El SOC quiere que MDE pueda bloquear y remediar artefactos maliciosos detectados después de la ejecución, sin reemplazar el AV de terceros. ¿Qué advanced feature activan?
A) Tamper protection · B) Live response · C) Custom network indicators · D) EDR in block mode

**P4.** Un device group tiene automation level "Semi – require approval for non-temp folders remediation". AIR encuentra un archivo malicioso en `C:\Users\jdoe\Downloads\invoice.exe`. ¿Qué ocurre?
A) Requiere aprobación manual porque Downloads no es systemfolder · B) Se remedia automáticamente porque Downloads está en la lista de carpetas temporales reconocidas por este nivel · C) AIR no actúa porque el nivel es "No automated response" · D) Se rechaza automáticamente a los 7 días

**P5.** Quieres crear una regla de custom data collection que capture ejecuciones de PowerShell en 20 servidores administrativos específicos. ¿Qué debes configurar ANTES de poder crear la regla?
A) Una analytics rule en Sentinel · B) Una automation rule · C) Una dynamic tag en Asset Rule Management que identifique esos 20 servidores · D) Un playbook de Logic Apps

### Respuestas explicadas

> [!note]- Ver respuestas (spoiler)
> **P1 — A.** Es la estrategia oficial documentada por Microsoft: Audit primero (2-4 semanas), revisar impacto, luego Block gradual empezando por las Standard protection rules (menor disrupción).
> **P2 — C.** Junto con la regla de LSASS, esta es una de las dos únicas ASR rules documentadas como incompatibles con Warn.
> **P3 — D.** EDR in block mode existe exactamente para este escenario: AV de terceros como protección principal + Defender Antivirus en modo pasivo + necesidad de que el motor EDR bloquee post-brecha.
> **P4 — B.** El nivel "non-temp folders" invierte el criterio del nivel "core folders": remedia automáticamente en carpetas temporales conocidas (incluye `\downloads\*`) y requiere aprobación para todo lo demás.
> **P5 — C.** Custom data collection requiere targeting por dynamic tags configuradas primero en Asset Rule Management — es un prerequisito documentado explícitamente, no es opcional ni se puede usar tags manuales.

---

*Relacionadas: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[MAPA_DIARIO_LEARN_LABS]] · [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] · [[03_Semana3_Defender_XDR]]*
