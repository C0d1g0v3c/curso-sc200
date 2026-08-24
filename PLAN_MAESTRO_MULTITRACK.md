---
tags: [sc-200, ccna, htb, plan, calendario, multitrack]
creado: 2026-08-09
actualizado: 2026-08-23
examen_sc200: 2026-10-03
examen_sc200_recomendado: 2026-10-24 (pendiente de confirmación explícita del alumno — ver §7)
estado: 🟡 Reanclaje #4 en curso — fecha de examen pendiente de confirmación
---

# 🗺️ Plan maestro multitrack — agosto a octubre 2026

> [!important] Este documento sustituye al cronograma de [[GUIA_INTENSIVA_24_DIAS]] §2
> El "Reanclaje #2" del 29-jul asumía SC-200 como ocupación única. Esa premisa murió
> el **5 de agosto**, cuando arrancó el semestre. Este es el **Reanclaje #3** y el primero
> que se construye contando con el resto de la vida del alumno.

---

## 1. Diagnóstico: por qué se atascó

El Día 8 del SC-200 se impartió el **5 de agosto**. El curso CCNA ITN arrancó el **5 de agosto**.
El Día 9 nunca ocurrió. La colisión es exacta y la causa es estructural, no de disciplina:
el plan pedía una lección diaria a alguien que ese mismo día empezó un semestre con
**4+ materias**.

Cualquier plan nuevo que vuelva a asumir ritmo diario fracasará por el mismo motivo.

---

## 2. Los tres tracks y su jerarquía

| Track | Ventana | Naturaleza | Rol en el plan |
|---|---|---|---|
| **Universidad** (4+ materias, incl. CCNA ITN) | 5 ago → 19 dic 2026 | Fija, con instructor y fechas propias | **Intocable.** Se planifica alrededor de ella |
| **SC-200** | Examen **sáb 3 oct 2026** · muro del voucher **30 oct** | Movible pero con muro duro | **El que marca el ritmo.** Es lo único que caduca |
| **HTB Academy** (SOC path) | Sin fecha, autoguiado | Totalmente flexible | **Amortiguador. En pausa hasta el 4-oct** |

> [!note] Por qué HTB es lo que cede
> No es que importe menos. Es lo único de los tres que **no te penaliza por esperar**:
> no tiene fecha, no tiene instructor y no caduca. Lleva sin tocarse desde el 22-jun,
> así que la pausa formaliza algo que ya venía pasando de hecho. Se retoma el **4 de octubre**,
> al día siguiente del examen.

---

## 3. Ritmo semanal

En lugar de fechas heroicas, un **patrón repetible** que sobreviva a una semana mala:

| Día | Bloque | Duración |
|---|---|---|
| **Martes** | Lección SC-200 | 1–1.5 h |
| **Jueves** | Lección SC-200 | 1–1.5 h |
| **Sábado** | 🔬 **Bloque grande**: lab práctico o simulacro | 2–3 h |
| **Domingo** | Lección SC-200 + quiz del día | 1.5–2 h |
| Lun / Mié / Vie | **Universidad y CCNA.** SC-200 no entra aquí | — |

**3 lecciones por semana**, no 7. Son ~6 h semanales de SC-200: cabe al lado de un semestre completo.
Las 16 lecciones restantes salen en 5 semanas y media, y quedan **3 semanas limpias** de
simulacros y repaso antes del examen.

> [!warning] La regla que hace que esto funcione
> **El sábado es el recurso escaso, no las tardes.** Los labs necesitan bloque continuo con
> el tenant abierto; una lección no. Si una semana hay que sacrificar algo, se sacrifica
> una lección entre semana — **nunca el sábado**. El atraso anterior se produjo exactamente
> por lo contrario: se acumularon 5 labs mientras las lecciones seguían corriendo.

> [!note] Canal nuevo (23-ago): podcasts de NotebookLM en tiempos muertos
> No es un bloque nuevo — es un **canal pasivo que corre sobre los tiempos muertos** (traslados,
> tareas mecánicas), sin restar minutos a los cuatro bloques protegidos de la tabla de arriba.
> Ver detalle completo en §7.4. Regla corta: **la lección escrita con quiz siempre existe primero**;
> el audio se genera a partir de ella, nunca al revés — el quiz es lo único que mide si el alumno
> aprendió, y eso no se sustituye escuchando un resumen.

---

## 4. Calendario

> [!warning] Estado real al 23-ago-2026 — la tabla de abajo ya no coincide con lo ejecutado
> Esta tabla es el calendario **original** del Reanclaje #3 (9-ago). El diagnóstico de por qué
> se separó del plan real, los números exactos de atraso y qué pasa de aquí en adelante están
> en **§7 (Reanclaje #4)**. Para los labs atrasados de los Días 4-9, usa la guía consolidada
> [[LABS_CONSOLIDADOS_Dias_4_a_9]] en vez de las fechas sueltas que aparecen abajo.

### Agosto

| Fecha | Track | Qué toca |
|---|---|---|
| **Dom 9 ago** | ⚙️ Logística | **Reprogramar el examen a sáb 3-oct** + triage del temario viejo (30 min) |
| Mar 11 ago | SC-200 | **Día 9** — Respuesta MDE: timeline, live response, evidence |
| Mié 12 ago | CCNA | 📌 **Módulo 5 — Sistemas numéricos** (prerequisito de subnetting) |
| Jue 13 ago | SC-200 | **Día 10** — MDO (Threat Explorer, ZAP) + MDCA |
| **Sáb 15 ago** | 🔬 Lab | **Labs atrasados Días 4 y 5** — Scheduled rule + Anomalies + blade MITRE · ASR + advanced features + device group |
| Dom 16 ago | SC-200 | **Día 11** — Identidades: Entra ID Protection + MDI |
| **Lun 17 ago** | ⚠️ | **Último día útil antes del vencimiento del voucher** — verificar que la cita del 3-oct está confirmada |
| Mar 18 ago | SC-200 | **Día 12** — Defender for Cloud workload protections |
| Mié 19 ago | CCNA | 📌 **Módulo 11 — Direccionamiento IPv4** |
| Jue 20 ago | SC-200 | **Día 13** — Purview Audit, eDiscovery, Graph + Copilot embebido · **cierra Dominio 2** |
| **Sáb 22 ago** | 🔬 Lab | **Lab atrasado Día 6** (automation rule + playbook + permisos) **+ Simulacro #2** |
| Dom 23 ago | SC-200 | **Día 14** — KQL total: repaso + drill "¿qué tabla uso para X?" |
| Mar 25 ago | SC-200 | **Día 15** — Advanced Hunting + custom detections + hunting graphs / Sentinel Graph |
| Mié 26 ago | CCNA | 📌 **Examen de punto de control** — Comunicaciones de aplicaciones de red |
| Jue 27 ago | SC-200 | **Día 16** — Hunting en Sentinel: queries, bookmarks, livestream, hunts |
| **Sáb 29 ago** | 🔬 Lab | **Labs atrasados Días 7 y 8** — workbooks + SOC optimization · Manage incident pane + Cases · **deuda de labs a cero** |
| Dom 30 ago | SC-200 | **Día 17** — Data lake, KQL jobs, Summary rules, Notebooks + MCP Server |

### Septiembre

| Fecha | Track | Qué toca |
|---|---|---|
| Mar 1 sep | SC-200 | **Día 18** — KQL avanzado gamificado · **cierra Dominio 3** |
| Jue 3 sep | 🟢 Libre | Colchón. Si algo se cayó en agosto, se recupera aquí |
| **Sáb 5 sep** | 🔬 Lab | **Día 19** — Lab integral end-to-end |
| Dom 6 sep | SC-200 | **Día 20** — Refuerzo dirigido sobre los fallos del Simulacro #2 |
| Mar 8 sep | SC-200 | **Día 21** — Repaso Dominio 1 + Dominio 2 completos |
| **Sáb 12 sep** | 📊 **Simulacro #3** | **Día 22 — PUNTO DE DECISIÓN.** Meta >70 % |
| Dom 13 sep | SC-200 | **Día 23** — Flashcards + trampas + logística |
| Mar 15 sep | SC-200 | **Día 24** — Repaso ligero + [exam sandbox](https://aka.ms/examdemo) · **fin del contenido** |
| Jue 17 sep | Refuerzo | Áreas por debajo del 70 % en el Simulacro #3 |
| **Sáb 19 sep** | 📊 **Simulacro #4** | Meta >80 % |
| Dom 20 – Jue 24 sep | Refuerzo | Bloques débiles medidos: **MDE response** y **Purview Audit/eDiscovery** |
| **Sáb 26 sep** | 📊 **Simulacro #5** | Meta >85 %. Última medición real |
| Dom 27 – Jue 1 oct | Repaso | Los 5 temas de plataforma nuevos: data lake, KQL jobs, summary rules, Sentinel Graph, MCP Server |

### Octubre

| Fecha | Qué toca |
|---|---|
| Vie 2 oct | Víspera. Solo flashcards y trampas. **Nada nuevo.** Dormir 7+ h |
| **Sáb 3 oct** | 🎯 **EXAMEN SC-200** |
| Dom 4 oct | 🔓 **Se reanuda HTB Academy** |

---

## 5. Puntos de decisión

> [!warning] Sáb 12 sep — Simulacro #3
> **Si queda por debajo del 70 %, reprogramar el examen al sábado 24 de octubre.**
> Es el **último sábado posible**: el muro del voucher para la fecha de examen es el
> 30-oct-2026, y el 31 ya se pasa. Reprogramar es gratis con más de 24 h de anticipación.
>
> Elegir el 3-oct en vez de irse directo a octubre fue deliberado: **deja tres sábados
> de reserva** (10, 17 y 24 de oct). Gastar todo el margen de golpe es lo que dejó sin
> salida a los dos reanclajes anteriores.

> [!note] Regla de deriva
> Si al terminar agosto quedan **dos o más lecciones sin impartir** respecto a este
> calendario, no se re-planifica otra vez: se ejecuta directamente el movimiento al 24-oct.
> Tres reanclajes son suficientes.

---

## 6. Estado de partida (9 ago 2026)

**SC-200 — hecho:** Días 1–8 impartidos · quizzes 1–6 aprobados · Simulacro 01 (23-jul) al 46 %
**SC-200 — pendiente:** 16 lecciones (Días 9–24) · 5 labs (Días 4, 5, 6, 7, 8) · 2 quizzes (Días 7 y 8)
**CCNA ITN:** 0/17 módulos marcados · 3 tareas NetAcad pendientes (M5, M11, checkpoint)
**HTB:** en pausa desde el 22-jun, formalizado hasta el 4-oct

---

## 7. Reanclaje #4 (23-ago-2026) — diagnóstico, canal de podcasts y recomendación de fecha

### 7.1 El número real de atraso

El Reanclaje #3 (9-ago) diseñó un ritmo de 3 lecciones/semana + 1 sábado grande. Dos semanas después, esto es lo que pasó de verdad, no lo que se planeó:

| Medido | Plan (Reanclaje #3) | Real al 23-ago | Diferencia |
|---|---|---|---|
| Lecciones impartidas | Día 14 (hoy tocaría) | Día 9 (12-ago) | **5 lecciones sin dar**: Días 10, 11, 12, 13, 14 |
| Sábados grandes ejecutados | 2 de 2 (15-ago, 22-ago) | 0 de 2 | **Los dos en cero**, no uno |
| Labs con lección/quiz ya cerrados pero práctica pendiente | Debía llegar a 0 el 29-ago | 6 (Días 4, 5, 6, 7, 8, 9) | Aumentó en vez de bajar |
| Simulacro #2 (agendado 22-ago) | Hecho | No hecho | 1 simulacro completo perdido |
| Quiz + repaso acumulativo del Día 9 | Respondidos | Sin responder | 2 pendientes |
| Dominio 2 (debía cerrar en el Día 13) | Cerrado | Abierto | Cierre sin fecha |

**Lectura sin adornos:** el patrón "3 lecciones + 1 sábado grande" **no se sostuvo ninguna de las dos semanas** en la parte que más importaba — el sábado, que era justo el recurso que el Reanclaje #3 marcó como "el que nunca se sacrifica". No es un fallo de disciplina puntual: son dos semanas consecutivas en cero en la misma variable. Un patrón que falla dos veces seguidas en su punto de diseño central no es una mala semana, es que el diseño no encajó con la carga real de agosto.

### 7.2 La regla de deriva ya está disparada — recomendación, no ejecución automática

La regla fijada en el Reanclaje #3 (§5) dice: *"si al terminar agosto quedan 2+ lecciones sin impartir, se ejecuta el movimiento al 24-oct sin volver a replanificar."* Hoy es 23-ago, faltan 8 días para fin de mes, y el contador **ya está en 5 lecciones**, no 2 — el umbral se superó por más del doble, y aún queda una semana donde el patrón tendría que revertirse por completo (recuperar 5 lecciones + 2 sábados + 1 simulacro en 8 días, encima de universidad y CCNA) para no terminar agosto muy por encima del umbral.

**Recomendación explícita: mover el examen al sábado 24 de octubre de 2026.** No por castigo — por aritmética: da 3 semanas adicionales de colchón real (dos de labs/contenido + repaso extra) en vez de forzar una recuperación que ya falló dos veces seguidas bajo el mismo diseño. Es, además, exactamente el escenario para el que se reservaron los tres sábados de octubre desde el Reanclaje #3: gastar ese margen ahora, con datos en la mano, es usarlo como se diseñó — no es un tercer fracaso, es el plan de contingencia funcionando.

> [!important] Esto queda PENDIENTE de confirmación explícita del alumno
> Esta nota **no reprograma la cita**. `examen_sc200` en el frontmatter de este documento
> sigue en **2026-10-03** hasta que el alumno confirme el cambio. La fecha recomendada
> (2026-10-24) queda registrada en el frontmatter como `examen_sc200_recomendado` solo como
> referencia. Reprogramar con Pearson VUE / Certiport es gratis con +24h de anticipación —
> no hay urgencia de decidirlo en este mismo minuto, pero sí antes de que se acerque más al
> 3-oct, porque la ventana de gratis-con-24h se estrecha.

### 7.3 Qué no cambia con esta recomendación

- El **muro duro del voucher sigue siendo el 30-oct-2026** — moverse al 24-oct no lo toca, solo consume uno de los tres sábados de reserva (quedarían 2: nada más, ya no hay margen extra después de este movimiento).
- El **Punto de decisión del Simulacro #3 (originalmente 12-sep)** se recalcula una vez que la fecha de examen quede confirmada — no tiene sentido fijar hoy una fecha de simulacro que depende de cuántas semanas de colchón realmente haya.
- La recalendarización completa de septiembre y octubre (qué día toca cada lección/lab/simulacro con la nueva fecha) se hace en la **próxima sesión**, una vez el alumno confirme el movimiento — hacerlo hoy sin esa confirmación sería el mismo error de "replanificar antes de tener la decisión firme" que ya causó reanclajes anteriores.

### 7.4 Canal nuevo: podcasts de NotebookLM en tiempos muertos

El alumno propuso usar el **Audio Overview de Gemini NotebookLM** (genera un podcast conversacional a partir de las fuentes que subas) para consumir contenido en trayectos y tareas mecánicas, sin competir con los bloques dedicados. La herramienta ya existe y no hace falta nada nuevo — el diseño es solo cómo encaja en el ritmo.

**Decisión de secuencia: la lección escrita con quiz SIEMPRE se genera primero. El podcast sale de ella, nunca al revés.**

Razones, no es una preferencia arbitraria:

1. **Verificación.** Cada lección de este curso se escribe verificando contra Microsoft Learn los datos volátiles (nombres de tabla, rutas de portal, fechas de retiro — el curso ya lleva varios hallazgos así, como el retiro de AIR o el split de `ThreatIntelligenceIndicator`). Un Audio Overview generado directamente de documentación cruda, sin ese filtro, hereda el riesgo de traer un dato ya viejo o mal resumido como primera exposición. Generarlo a partir de la lección ya verificada blinda esa exposición inicial.
2. **El error medido en este curso no es de exposición, es de reflejo bajo presión.** El patrón repetido en el tracker (Timeline vs Advanced Hunting, `SecurityAlert` vs `SecurityIncident`, workbook vs playbook) no es "nunca lo escuchó" — es "no detectó el calificador del enunciado a tiempo". Eso se entrena **leyendo un enunciado y decidiendo activamente**, no escuchando un resumen. El quiz es insustituible; el podcast no puede medir retención, solo generar exposición.
3. **Mejor uso del podcast: atacar la degradación de lo YA aprendido, no la primera pasada de lo nuevo.** El dato más caro de este curso hasta ahora es que el quiz del Día 7 cayó de aprobado a 3/5 solo 11 días después, por pura degradación de memoria — no por mal entendido. Eso es exactamente el problema que un repaso auditivo frecuente en tiempos muertos sí resuelve bien.

**Diseño concreto (no agrega bloques, usa tiempo que ya existe):**

- **Un solo Notebook maestro** en NotebookLM para todo el curso (no uno por día — se perdería el contexto acumulado entre días). Fuentes: las lecciones ya escritas de `Lecciones Diarias/` (Días 1-9 hoy, se agregan las nuevas según se vayan cerrando) + `REPASO_RAPIDO_Errores_Simulacro.md` (para que el audio hable en los mismos términos que los errores reales medidos, no en genérico).
- **Overview de repaso acumulativo** (fuente: `REPASO_RAPIDO_...` + Días 1-9 ya escritos): se puede generar **hoy mismo**, sin esperar contenido nuevo — es pura ganancia inmediata sobre el backlog de retención ya medido.
- **Overview por lección nueva**, generado **después** de que cada lección se entregue completa (con quiz): se escucha en el tiempo muerto **entre** el bloque en que se impartió y el siguiente bloque dedicado — por ejemplo, la del martes se escucha el miércoles en el trayecto a la universidad, para llegar el jueves (si el jueves trae contenido relacionado) o al domingo con la exposición ya fresca.
- **Regla dura:** el podcast nunca sustituye ni el quiz ni el bloque del sábado. Si en algún momento la tentación es "ya lo escuché, me salto la lección de hoy", esa es la misma confusión entre exposición y dominio que ya costó puntos en el Simulacro 01 — el canal existe para sumar repetición espaciada, no para recortar bloques protegidos.

| Día | Bloque protegido (sin cambios) | Canal pasivo nuevo (sin horario fijo, tiempos muertos) |
|---|---|---|
| Martes | Lección SC-200 nueva | — |
| Miércoles | Universidad / CCNA | Overview de la lección del martes (refuerzo) |
| Jueves | Lección SC-200 nueva | — |
| Viernes | Universidad / CCNA | Overview de la lección del jueves (refuerzo) |
| Sábado | 🔬 Bloque grande: labs / simulacro | — |
| Domingo | Lección SC-200 + quiz | Overview de repaso acumulativo (huecos medidos del tracker), cualquier rato libre |

### 7.5 Deuda de labs — plan inmediato

Detalle completo, con pasos y evidencia por lab, en [[LABS_CONSOLIDADOS_Dias_4_a_9]]. Resumen:

| Bloque | Contenido | Recurso | Duración real | Sábado propuesto |
|---|---|---|---|---|
| Bloque A | Días 4, 6, 7 (Sentinel: analytics rules, automation rules + playbooks, workbooks/roles/notificaciones) | Azure for Students (portal.azure.com) | ~3h10min | **29-ago** |
| Bloque B | Días 5, 8, 9 (MDE/Defender: ASR, device groups, case management, timeline/live response/evidencia) | Trial M365 E5 (security.microsoft.com) | ~2h40min | **5-sep** |

El Bloque A queda ligeramente por encima del presupuesto de 2-3h — la guía consolidada ya indica qué recortar primero sin perder lo que el tracker mide como débil (ver §2.4 de esa nota). Simulacro #2 necesita su propio sábado, todavía sin asignar — se agenda junto con la recalendarización de septiembre una vez confirmada la fecha de examen.

---

*Relacionado: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[TRACKER_CCNA]] · [[LABS_CONSOLIDADOS_Dias_4_a_9]] · [[REPASO_RAPIDO_Errores_Simulacro]]*
