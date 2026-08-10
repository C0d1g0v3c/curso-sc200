---
tags: [sc-200, ccna, htb, plan, calendario, multitrack]
creado: 2026-08-09
examen_sc200: 2026-10-03
estado: 🟢 Vigente
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

---

## 4. Calendario

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

*Relacionado: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[TRACKER_CCNA]]*
