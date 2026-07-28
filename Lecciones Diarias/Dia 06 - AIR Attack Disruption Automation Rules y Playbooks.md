---
tags: [sc-200, air, attack-disruption, automation-rules, playbooks, soar, defender-xdr, sentinel, leccion-diaria]
dia: 6
fecha: 2026-07-24
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
estado: ✅ Completada
cover: ""
---

# Lección Día 6 — AIR, Attack Disruption, Automation Rules y Playbooks

> [!info] Contexto
> Día 6 del plan de [[GUIA_INTENSIVA_24_DIAS]] (Dominio 1 — Manage a security operations environment, 40–45% del examen). Retomamos hoy 24 de julio: por el reanclaje de calendario del 13-jul "tocaría" fecha más adelante en el cronograma, pero por contenido este es el siguiente tema sin impartir (el `TRACKER_TUTOR.md` confirma que Días 4 y 5 quedaron con quiz aprobado y solo el lab práctico pendiente — nada se saltó). Hoy cerramos el bloque de **automatización** de MDE y Sentinel: qué actúa solo cuando encuentra evidencia maliciosa (AIR), qué actúa solo cuando detecta un ataque completo en curso (Attack Disruption), y cómo tú, como analista, construyes tu propia automatización a medida (Automation rules + Playbooks). Es uno de los bloques más preguntados del examen porque el examen ama poner escenarios casi idénticos entre sí y pedirte distinguir cuál mecanismo actuó.
>
> ⚠️ **Aviso sobre la guía del vault:** `GUIA_INTENSIVA_24_DIAS.md` describe bien la diferencia AIR/Attack Disruption/automation rules/playbooks a nivel de flashcard, pero **no menciona que AIR en Microsoft Defender for Endpoint se retira como experiencia separada el 1 de septiembre de 2026** (dato que ya adelantamos el Día 5, y que confirmo hoy con más detalle abajo) ni la ampliación reciente de las acciones de Attack Disruption. No es un error, es una omisión por tratarse de anuncios muy recientes — lo cubro completo en esta lección.

## 📖 Lectura del día

### 1. Automated Investigation and Response (AIR)

**AIR (Automated Investigation and Response)** es la capacidad de Microsoft Defender que, cuando una alerta dispara una investigación automática, examina **cada entidad relacionada con esa alerta** (el archivo, el proceso que lo lanzó, los procesos hijos, las claves de registro de persistencia que creó, los servicios que instaló, otros dispositivos donde aparece el mismo artefacto) para decidir si esa evidencia es realmente una amenaza y, si lo es, remediarla. Piensa en AIR como un investigador automático que reproduce los pasos que haría un analista humano — "¿qué tocó este archivo? ¿qué otros dispositivos lo tienen? ¿es parte de una cadena más larga?" — pero a máquina y en segundos.

El resultado de una investigación de AIR siempre es uno de tres **veredictos**:
- **Malicious** — se confirma amenaza; se ejecutan (o se proponen, según el automation level) acciones de remediación: cuarentena de archivo, terminar proceso, eliminar tarea programada de persistencia, etc.
- **Suspicious** — hay indicios pero no certeza total; normalmente requiere revisión humana antes de remediar.
- **No threats found** — la investigación cierra sola, sin acción.

¿Qué tan agresiva es la remediación? Eso ya lo viste el Día 5: lo decide el **automation level** del device group al que pertenece el dispositivo (Full, las tres variantes de Semi, o No automated response). Cuando una acción queda pendiente de aprobación (niveles Semi), aparece en el **Action Center** del portal de Defender, y si nadie la aprueba ni rechaza en **7 días**, se trata como rechazada automáticamente.

**Cambio importante confirmado en Microsoft Learn (verificado hoy, actualiza lo que adelantamos el Día 5):** a partir del **1 de septiembre de 2026**, AIR **deja de existir como experiencia de investigación separada en Microsoft Defender for Endpoint** y ya no podrá activarse manualmente — sus capacidades de detección y respuesta quedan absorbidas dentro de la protección antivirus por defecto (que ya corre automáticamente). Cualquier playbook, script o integración que dispare AIR manualmente en MDE dejará de funcionar después de esa fecha. **Esto aplica solo a Defender for Endpoint** — AIR en **Microsoft Defender for Office 365** (investigación automática de phishing/malware en correo) sigue funcionando sin cambios. Tu examen está agendado el 29 de agosto de 2026, antes del cambio, así que el modelo de automation levels que ya estudiaste sigue siendo examinable tal cual.

### 2. Automatic attack disruption

Si AIR investiga **una alerta y su evidencia local**, **Automatic attack disruption** (disrupción automática de ataques) trabaja en una capa distinta: mira el **incidente completo** — la correlación de señales de endpoints, identidades, correo/colaboración y apps SaaS — y cuando esa correlación describe con **muy alta confianza** un ataque sofisticado en curso (ransomware operado por humanos, compromiso de correo empresarial/BEC, adversary-in-the-middle/AiTM robando tokens), actúa de inmediato para **contener los activos que el atacante está usando para propagarse**, sin esperar a que un analista apruebe nada.

La lógica interna funciona en **tres etapas**:
1. Correlaciona señales de múltiples productos Defender en un único incidente de alta confianza.
2. Identifica qué activos (dispositivos, cuentas, direcciones IP) están bajo control del atacante y sirviendo para propagar el ataque.
3. Ejecuta automáticamente acciones de contención en los productos Defender relevantes, en tiempo real.

La confianza requerida es extremadamente alta: Microsoft mantiene un umbral de **99% o más de precisión** (medido como signal-to-noise ratio, es decir, la proporción de detecciones reales frente a falsos positivos) antes de que un detector de disrupción se libere en producción; cada detector nuevo pasa primero por un modo de auditoría y un despliegue gradual.

**Tabla de acciones que puede ejecutar** (esto es lo que más pregunta el examen — memoriza qué acción corresponde a qué producto):

| Acción | Producto | Qué hace |
|---|---|---|
| Contain device | Defender for Endpoint | Bloquea comunicación desde un dispositivo sospechoso, aplicando una política en todos los dispositivos onboardeados a MDE |
| Contain IP | Defender for Endpoint | Igual que arriba pero para una IP asociada a un dispositivo NO onboardeado/no descubierto |
| Isolate device | Defender for Endpoint | Aísla completamente un dispositivo comprometido identificado como punto de apoyo activo; bloquea casi todo el tráfico salvo servicios de seguridad esenciales |
| Disable user | Defender for Identity | Deshabilita la cuenta para impedir más inicios de sesión |
| Contain user | Defender for Endpoint | Bloquea comunicación de red asociada a una identidad sospechosa (reduce movimiento lateral y riesgo de cifrado remoto) |
| Revoke user session | Microsoft Entra ID | Revoca sesiones activas del usuario |
| Suspend user in Entra | Microsoft Entra ID | Suspende la cuenta directamente en Entra ID |
| OAuth app compromise | Defender for Cloud Apps | Ejecuta medidas de contención sobre una app OAuth potencialmente comprometida |
| Attach deny policy to AWS user | Sentinel (conector AWS, preview) | Bloquea permisos de un usuario/rol de AWS IAM comprometido |
| Suspend user in Okta | Sentinel (conector Okta, preview) | Suspende una cuenta Okta comprometida |

Además existe una categoría hermana llamada **Predictive shielding**, que actúa de forma preventiva sobre usuarios/dispositivos identificados como de alto riesgo **antes** de que el ataque escale a incidente confirmado: **Safeboot hardening** (bloquea manipulación vía reinicios en Modo seguro), **GPO hardening** (bloquea abuso de Group Policy) y **Proactive user containment** (restringe selectivamente a un usuario de alto riesgo, sin cortar sesiones existentes, a diferencia de Contain user que sí las corta).

**Diferencia clave AIR vs Attack Disruption (pregunta de examen garantizada):**
- **AIR** actúa **por dispositivo/alerta**, respeta el **automation level** configurado en el device group, y su alcance es la evidencia de esa alerta específica (archivo, proceso, persistencia).
- **Attack Disruption** actúa **a nivel de incidente completo**, con altísima confianza, e **ignora el automation level** — se ejecuta igual aunque el device group esté en "No automated response", porque su criterio de activación es independiente (basado en la correlación XDR, no en la configuración de AIR).

Si tienes activos críticos que nunca deben contenerse automáticamente (por ejemplo, un servidor de producción que rompería un proceso de negocio si se aísla), puedes configurar **exclusiones** por usuario, dispositivo o IP en la configuración de Attack Disruption — todas las acciones automáticas también pueden **deshacerse manualmente** después, el equipo de seguridad nunca pierde el control final.

En el portal de Defender, un incidente donde actuó Attack Disruption se identifica con: una etiqueta **"Attack Disruption"** en la cola de incidentes y en la página del incidente, una **barra amarilla** en la parte superior de la página describiendo la acción tomada, el estado del activo reflejado directamente en el gráfico del incidente (p. ej. "device contained"), y — vía API — el título del incidente termina con el sufijo **"(attack disruption)"**.

### 3. Automation rules

Una **automation rule** es el mecanismo central para gestionar automatización en Sentinel/Defender: te permite definir un conjunto pequeño de reglas que se aplican de forma transversal a incidentes y alertas, sin tener que repetir lógica en cada analytics rule.

Se compone de tres piezas:
- **Trigger** — qué evento dispara la regla: **When incident is created**, **When incident is updated** (cambio de estado, owner, severity, se agregan alertas/tags/comentarios), o **When alert is created** (solo para alertas generadas por reglas Scheduled, NRT o Microsoft security — no aplica a alertas nativas de Defender XDR sin pasar por Sentinel).
- **Conditions** — filtros sobre propiedades del incidente/alerta y de sus entidades. Para el trigger de creación se evalúan condiciones sobre el **estado actual** (equals, contains, starts with, ends with). Para el trigger de actualización se suman condiciones de **cambio de estado**: *changed*, *changed from*, *changed to*, *added* (por ejemplo, "el status cambió a Closed" o "se agregó un tag").
- **Actions** — qué hace la regla si se cumplen las condiciones: agregar una tarea al incidente, cambiar su estado (incluyendo motivo de cierre), cambiar severidad, asignar un owner, agregar un tag, o **ejecutar un playbook**. Puedes encadenar varias acciones y el orden en que se listan es el orden en que se ejecutan.

**Orden de ejecución (detalle que el examen adora):** cada tipo de trigger mantiene su propia "cola" de orden — primero se ejecutan, en su orden numérico, todas las reglas con trigger "incident created"; solo después corren las reglas con trigger "incident updated" (incluso si una regla de creación disparó una actualización). Dentro de la misma cola, las reglas corren **secuencialmente, nunca en paralelo**, y cada regla evalúa sus condiciones contra **el estado del incidente después de que las reglas anteriores ya actuaron** — no contra el estado original. Ejemplo textual de la documentación oficial: si la "Regla 1" baja la severidad de High a Low, y la "Regla 2" solo debía correr sobre incidentes con severidad Medium o superior, la Regla 2 **no se ejecuta**, porque para cuando le toca evaluar, la severidad ya es Low.

También puedes definir una **fecha de expiración** en una automation rule — muy útil para reglas temporales, como suprimir automáticamente los incidentes ruidosos generados durante una ventana de pentesting programado.

### 4. Playbooks (Logic Apps)

Un **playbook** es una Logic App de Azure — un flujo de trabajo low-code/no-code — que ejecuta acciones más complejas que las que una automation rule puede hacer por sí sola: enviar una notificación a Teams, consultar una API externa, crear un ticket en ServiceNow, aislar un dispositivo llamando al conector de Defender for Endpoint, enriquecer una IP contra un feed de threat intelligence, etc. Si la automation rule es el "orquestador" que decide cuándo y bajo qué condiciones actuar, el playbook es el "brazo ejecutor" que sabe cómo hacer algo complejo paso a paso.

Un playbook se construye sobre uno de dos tipos de disparador (trigger): **Microsoft Sentinel incident** (recibe el incidente completo con sus alertas y entidades) o **Microsoft Sentinel alert** (recibe una alerta individual sin incidente asociado). Esto importa porque **solo los playbooks con trigger de incidente pueden ser llamados desde automation rules con trigger de incidente**, y lo mismo para el par alerta/alerta — no se pueden mezclar.

**Permisos — el punto donde más falla la gente en el examen:** cuando una automation rule ejecuta un playbook, no lo hace con tu cuenta de usuario, sino con una **cuenta de servicio dedicada de Microsoft Sentinel**. Para que esa cuenta de servicio pueda ejecutar un playbook concreto, necesita el rol **Microsoft Sentinel Automation Contributor** otorgado explícitamente sobre el **resource group donde vive el playbook** (no sobre el playbook individual, y no sobre la suscripción completa). Una vez otorgado ese permiso sobre el resource group, **cualquier automation rule puede ejecutar cualquier playbook de ese resource group**. Si el permiso falta, el playbook aparece "en gris" (no seleccionable) en el desplegable de la automation rule; se resuelve desde el enlace **"Manage playbook permissions"**, que a su vez requiere que tú tengas el rol **Owner** sobre ese resource group para poder concederlo.

**Timing de ejecución dentro de una automation rule:** si un playbook tarda menos de 1 segundo, la regla avanza a la siguiente acción justo al terminar; si tarda menos de 2 minutos, la regla espera hasta 2 minutos (o hasta 10 segundos después de que el playbook termine, lo que ocurra primero); si tarda más de 2 minutos, la regla avanza de todas formas a los 2 minutos, haya terminado el playbook o no (el playbook sigue corriendo en segundo plano, pero la automation rule ya no espera su resultado).

Un dato histórico que aparece en preguntas de "trampa": antes de junio de 2023 se podía adjuntar un playbook **directamente a una analytics rule** (sin pasar por una automation rule). Esa vía **ya no existe** — hoy, la automation rule es el único mecanismo soportado para invocar un playbook automáticamente.

📝 Notas del vault relacionadas (revisar críticamente, no como fuente): [[PLAN_INTENSIVO_4SEMANAS]] (menciona playbooks y automation rules a nivel superficial), [[Modulo_3_Sentinel]]. Ninguna cubre en detalle el orden de ejecución por colas de trigger ni la tabla completa de acciones de Attack Disruption — quedan marcadas 🟡 en el mapeo de [[GUIA_INTENSIVA_24_DIAS]].

## 💡 Ejemplos concretos

**Ejemplo 1 — Distinguir AIR de Attack Disruption (tipo examen)**

*Escenario:* "Durante un ataque de ransomware operado por humanos, en cuestión de segundos Defender for Endpoint bloquea la comunicación de red de un dispositivo y Defender for Identity deshabilita la cuenta de usuario asociada, sin que ningún analista haya intervenido. El device group de ese dispositivo tiene el automation level 'No automated response'. ¿Qué explica esta respuesta automática?"

*Razonamiento:* El automation level "No automated response" desactiva específicamente a **AIR** para ese device group — pero **Automatic attack disruption es un mecanismo distinto** que evalúa el incidente completo con altísima confianza y actúa **sin importar el automation level configurado**, porque su criterio de activación no depende de esa configuración. La combinación "Contain device (MDE) + Disable user (MDI)" ejecutada en segundos y sin aprobación es la firma característica de Attack Disruption, no de AIR.

```kql
// Buscar incidentes donde actuó Automatic attack disruption en los últimos 30 días (Día 6)
SecurityIncident
| where TimeGenerated > ago(30d)
| where Title endswith "(attack disruption)" or Tags has "Attack Disruption"
| project TimeGenerated, IncidentNumber, Title, Severity, Status
| order by TimeGenerated desc
```

**Ejemplo 2 — Orden de ejecución de automation rules (tipo examen)**

*Escenario:* "'Regla A' (Order = 1, trigger: When incident is created) cambia automáticamente la severidad de todo incidente generado por la analytics rule 'Suspicious PowerShell activity' de High a Low, porque el SOC considera esa detección ruidosa. 'Regla B' (Order = 2, mismo trigger) está configurada para asignar el incidente al equipo Tier 2 solo si la severidad es High o Critical. Se crea un incidente de esa analytics rule. ¿Se asigna al equipo Tier 2?"

*Razonamiento:* No. Las reglas del mismo tipo de trigger corren secuencialmente según su **Order**. Regla A corre primero y baja la severidad a Low. Cuando le toca correr a Regla B, evalúa el **estado actual** del incidente — que ya es Low, no High — así que su condición no se cumple y la acción de asignación nunca se ejecuta. Si el SOC quisiera que Regla B sí actuara, tendría que invertir el orden (Regla B con Order menor que Regla A) o basar la condición de Regla B en el nombre de la analytics rule en vez de la severidad.

**Ejemplo 3 — Permisos de playbook (tipo examen)**

*Escenario:* "Un analista crea una automation rule y quiere agregar la acción 'Run playbook: Isolate-Device-and-Notify', pero el playbook aparece en gris y no se puede seleccionar. El analista tiene rol Sentinel Contributor. ¿Qué falta y cómo se soluciona?"

*Razonamiento:* Falta que la cuenta de servicio de Microsoft Sentinel tenga el rol **Microsoft Sentinel Automation Contributor** sobre el **resource group** donde vive ese playbook — Sentinel Contributor (el rol del analista) no incluye ese permiso, son roles distintos con propósitos distintos. La solución es abrir el enlace **"Manage playbook permissions"** desde el propio wizard de la automation rule y conceder el rol sobre el resource group; para hacerlo, quien lo conceda necesita permisos **Owner** sobre ese resource group específico (no sobre la suscripción completa).

## 🎥 Videos

1. **"Attack Disruption: Live demo"** — [Microsoft Learn Shows, serie Microsoft Sentinel & Defender XDR Virtual Ninja Training](https://learn.microsoft.com/en-us/shows/microsoft-sentinel-defender-xdr-virtual-ninja-training/attack-disruption-live-demo), con Mattias Borg (Threat Hunter y MVP de Microsoft). ~19 minutos (00:00 intro, 07:22 demo en vivo, 16:03 insights de attack disruption). Muestra la anatomía completa de un ataque simulado y cómo Attack Disruption lo contiene en tiempo real — el mejor recurso gratuito y reciente que encontré sobre este tema exacto.
2. Para automation rules y playbooks: no encontré un video de YouTube reciente (2025-2026) que cubra específicamente el **orden de ejecución por colas de trigger** y los **permisos de Automation Contributor** con el nivel de detalle que necesitas para el examen — la mayoría del contenido en video es de 2022-2023 y ya no refleja el modelo actual de order/queues. En su lugar, usa el módulo oficial y actualizado: [Automate threat response in Microsoft Sentinel with automation rules](https://learn.microsoft.com/en-us/azure/sentinel/automate-incident-handling-with-automation-rules) (documento base de esta lección, actualizado 30-jun-2026) y el tutorial práctico [Use a Microsoft Sentinel playbook to stop potentially compromised users](https://learn.microsoft.com/en-us/azure/sentinel/automation/tutorial-respond-threats-playbook), que trae un ejercicio guiado paso a paso.

## 🧪 Ejercicio práctico

> [!info] Requisito
> Usa tu trial M365 E5 / suscripción Azure for Students con Sentinel habilitado. Recuerda dejar la VM en "Stopped (deallocated)" si la usas, para no gastar crédito.

- [ ] **Paso 1 — Crear una automation rule simple.** En Sentinel (o el portal unificado de Defender) ve a **Automation → Create → Automation rule**. Trigger: "When incident is created". Condición: Severity equals High. Acciones: "Change status" a Active + "Add tag" con el texto "Revisado-Dia6". Guarda con Order = 1.
- [ ] **Paso 2 — Crear un playbook mínimo.** Desde **Automation → Playbooks → Add playbook (Consumption)**, crea una Logic App con trigger "Microsoft Sentinel incident" y un solo paso "Compose" (o "Post message in a Teams channel" si tienes Teams disponible). No necesita hacer nada destructivo — el objetivo es ver el flujo de creación y el trigger correcto.
- [ ] **Paso 3 — Intentar llamarlo desde la automation rule.** Vuelve a tu automation rule del Paso 1, agrega la acción "Run playbook" y selecciona el que acabas de crear. Si aparece en gris, sigue el enlace "Manage playbook permissions" y otorga el rol Microsoft Sentinel Automation Contributor sobre el resource group correspondiente — documenta si tu cuenta tenía o no el permiso Owner necesario para hacerlo.
- [ ] **Paso 4 — Revisar Attack Disruption en el portal de Defender.** Ve a **Settings → Microsoft Defender XDR → Attack disruption** (si tu tenant lo expone) y revisa qué acciones están habilitadas y si hay exclusiones configuradas. Si tu tenant universitario tiene el portal unificado limitado (como en sesiones anteriores), documenta el hallazgo y en su lugar lee [Configure attack disruption capabilities](https://learn.microsoft.com/en-us/defender-xdr/configure-attack-disruption).
- [ ] **Paso 5 —** corre la query KQL del Ejemplo 1 contra tu workspace (aunque probablemente devuelva 0 filas, sirve para validar la sintaxis contra la tabla `SecurityIncident`).
- [ ] **Paso 6 —** responde el quiz de hoy.

## ✅ Quiz del día

**P1.** Durante un ataque de ransomware operado por humanos, Defender for Endpoint contiene automáticamente un dispositivo y Defender for Identity deshabilita la cuenta de usuario asociada, en segundos y sin intervención humana. El device group de ese dispositivo tiene automation level "No automated response". ¿Qué explica esta respuesta?
A) AIR ignoró el automation level configurado por error de configuración
B) Automatic attack disruption actúa a nivel de incidente con alta confianza, independientemente del automation level del device group
C) Fue un playbook disparado manualmente por un analista de Tier 3
D) El automation level "No automated response" en realidad solo aplica a archivos, no a dispositivos ni usuarios

**P2.** "Regla A" (Order=1, trigger "When incident is created") cambia la severidad de un incidente de High a Low. "Regla B" (Order=2, mismo trigger) solo debe ejecutar su acción si la severidad es High o Critical. ¿Qué ocurre con Regla B sobre ese incidente?
A) Regla B se ejecuta igual porque evalúa el estado original del incidente antes de cualquier cambio
B) Regla B no se ejecuta porque evalúa el estado actual del incidente (ya en Low) después de que Regla A corrió primero
C) Ambas reglas corren en paralelo así que el resultado es indeterminado
D) El orden no importa porque las automation rules no se afectan entre sí

**P3.** Un playbook aparece "en gris" (no seleccionable) al intentar agregarlo como acción "Run playbook" en una automation rule. ¿Cuál es la causa más probable y su solución?
A) El playbook usa Logic Apps Standard, incompatible con automation rules
B) Falta el rol Microsoft Sentinel Automation Contributor sobre el resource group donde vive el playbook; se otorga desde "Manage playbook permissions" con permisos Owner sobre ese RG
C) El playbook no tiene entidades mapeadas
D) Automation rules solo permiten llamar un playbook por workspace

**P4.** ¿Qué describe correctamente el cambio de AIR que entra en vigor el 1 de septiembre de 2026?
A) AIR desaparece de todos los productos Defender, incluyendo Defender for Office 365
B) AIR deja de existir como experiencia de investigación separada y de poder activarse manualmente en Microsoft Defender for Endpoint; sus capacidades se integran en la protección antivirus por defecto. Defender for Office 365 no se ve afectado
C) Attack Disruption reemplaza completamente a AIR en todos los escenarios y productos
D) Todos los device groups pasan obligatoriamente a automation level Full sin opción de cambiarlo

**P5.** Quieres consultar en KQL todos los incidentes de los últimos 30 días donde actuó Automatic attack disruption. ¿Qué tabla y qué campo revisas?
A) SecurityAlert, campo AlertName
B) SecurityIncident, campo Title (sufijo "(attack disruption)") o Tags
C) DeviceEvents, campo ActionType con prefijo "Asr"
D) IdentityLogonEvents, campo ActionType

### Respuestas explicadas

> [!note]- Ver respuestas (spoiler)
> **P1 — B.** Attack Disruption evalúa el incidente completo con altísima confianza y actúa sin importar el automation level del device group, que solo controla a AIR.
> **P2 — B.** Las automation rules del mismo trigger corren secuencialmente según su Order, y cada regla evalúa el estado actual del incidente después de que las reglas previas ya actuaron — no el estado original.
> **P3 — B.** El rol correcto es Microsoft Sentinel Automation Contributor sobre el resource group del playbook (no sobre el playbook individual ni la suscripción); se concede desde "Manage playbook permissions" y requiere Owner sobre ese RG.
> **P4 — B.** El retiro de AIR como experiencia manual/separada aplica solo a Microsoft Defender for Endpoint; Defender for Office 365 sigue con AIR sin cambios.
> **P5 — B.** Los incidentes viven en la tabla `SecurityIncident`; Attack Disruption se identifica por el sufijo "(attack disruption)" en el título o por el tag "Attack Disruption".

---

*Relacionadas: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[MAPA_DIARIO_LEARN_LABS]] · [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] · [[Modulo_3_Sentinel]]*
