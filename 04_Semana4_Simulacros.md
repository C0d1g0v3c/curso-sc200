---
tags: [sc-200, simulacros, practica, examen, semana4]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: 🟡 En construcción
tipo: Estudio
relacionado: "[[00_INDEX_SC200]], [[03_Semana3_Defender_XDR]]"
---

# 🎯 Semana 4 — Simulacros y Estrategia de Examen

> **Idea central:** La semana 4 es 100% práctica. No estudias contenido nuevo — mides lo que sabes, encuentras huecos, los tapas, y agendas el examen.

---

## Checklist de la Semana

- [ ] Practice test 1 (score baseline — sin preparación extra)
- [ ] Identificar 3 áreas con score < 70%
- [ ] Repasar notas de esas áreas
- [ ] Practice test 2 (meta: 75%+)
- [ ] Practice test 3 (meta: 80%+)
- [ ] Canjear voucher del AI Skills Fest 2026
- [ ] Agendar examen en Pearson VUE Online
- [ ] 🎯 Presentar examen SC-200

---

## Recursos de Práctica

| Recurso | Costo | Calidad |
|---------|-------|---------|
| Udemy — Simulado SC-200 2026 | ~$12 USD | ⭐⭐⭐⭐⭐ |
| Microsoft Learn — Practice Assessment | Gratis | ⭐⭐⭐⭐ |
| MeasureUp (oficial Microsoft) | $99 USD | ⭐⭐⭐⭐⭐ |
| Whizlabs | ~$20 USD | ⭐⭐⭐⭐ |

> 💡 Empieza con el de Microsoft Learn (gratis) como diagnóstico, luego usa Udemy Simulados para práctica real.

---

## Mis Scores de Práctica

| # | Fecha | Score | % | Área débil 1 | Área débil 2 |
|---|-------|-------|---|-------------|-------------|
| Test 1 (baseline) | | | | | |
| Test 2 | | | | | |
| Test 3 | | | | | |
| **EXAMEN REAL** | | | | | |

---

## Estrategia para el Día del Examen

### Antes
```
✅ Dormir 7-8 horas (no estudiar hasta las 3am)
✅ Revisar CHEATSHEET_KQL 30 minutos antes
✅ Tener ID oficial listo (INE / pasaporte)
✅ Conexión estable + cuarto tranquilo (si es online)
✅ Agua en el escritorio
```

### Durante el Examen
```
TIEMPO: 120 minutos para ~50 preguntas = ~2.4 min/pregunta

Estrategia de tiempo:
├─ Primera pasada: responde las que sabes seguro (1 min c/u)
├─ Segunda pasada: trabaja las dudosas (3-4 min c/u)
└─ Tercera pasada: las que no sabes → elimina opciones obvias

Para preguntas de KQL:
├─ Lee la pregunta buscando el objetivo de la query
├─ Elimina opciones que no tienen el operador lógico correcto
├─ Si hay summarize → necesita un campo para agrupar
└─ Si dice "filtra" → busca where

Para preguntas de configuración:
├─ "Which tool" → piensa en el producto correcto del ecosistema
├─ MDE = endpoints, MDI = identidades AD, MDO = email
└─ Si dice "automate response" → Playbooks / Logic Apps
```

---

## Temas de Mayor Peso — Repaso Final

### 🔴 KQL (aparece en ~30% del examen de forma implícita)

```kql
// Las 5 queries que debes poder escribir de memoria:

// 1. Brute force detection
SecurityEvent | where EventID == 4625
| summarize count() by Account | where count_ > 10

// 2. Filtrar por tiempo
| where TimeGenerated > ago(24h)

// 3. Agrupar por tiempo (bin)
| summarize count() by bin(TimeGenerated, 1h)

// 4. Top N resultados
| order by count_ desc | take 10

// 5. Join básico
table1 | join kind=inner (table2) on CampoComún
```

### 🔴 Analytics Rules — Tipos y Cuándo Usar

```
Scheduled   → KQL personalizado, intervalos regulares (default)
NRT         → Latencia ~1min, alertas críticas inmediatas
Fusion      → ML de Microsoft, multi-stage attacks, no editar
Anomaly     → ML de comportamiento, necesita 7d de aprendizaje
MS Security → Convierte alertas de Defender en incidents
```

### 🔴 Defender XDR — Acciones de Respuesta

```
MDE:  Isolate → Stop & Quarantine → Collect Package → Live Response
MDI:  Disable user → Force password reset
MDO:  Delete email → Block sender → Soft delete
MDC:  Apply recommendation → Enable Defender plan
```

### 🟡 Playbooks — Triggers

```
Incident trigger  → Automatizar cuando se CREA un incident
Alert trigger     → Automatizar por cada alerta individual
Entity trigger    → Al enriquecer una entidad específica
```

### 🟡 Roles de Sentinel (RBAC)

```
Microsoft Sentinel Reader      → Solo ver (analistas Jr.)
Microsoft Sentinel Responder   → Ver + gestionar incidents + playbooks
Microsoft Sentinel Contributor → Todo excepto asignar roles
Microsoft Sentinel Automation Contributor → Para playbooks automáticos
```

---

## Preguntas Trampa Comunes

> Estas son las que más gente falla — léelas con cuidado

**Trampa 1**: "You need to detect lateral movement across AD with minimal latency"
→ Respuesta: **Defender for Identity** (no Sentinel directamente)

**Trampa 2**: "You want to automatically isolate a device when a High incident is created"
→ Respuesta: **Playbook** (Logic App con trigger de incident, no analytics rule)

**Trampa 3**: "You need to query logs from the last 7 days"
→ Respuesta: `| where TimeGenerated > ago(7d)` (no `> ago(168h)` aunque sea equivalente)

**Trampa 4**: "Which rule type detects multi-stage attacks automatically?"
→ Respuesta: **Fusion** (no Scheduled ni Anomaly)

**Trampa 5**: "You want to improve your organization's security posture score"
→ Respuesta: **Defender for Cloud** Secure Score + Recommendations (no Sentinel)

---

## Canjes del Voucher

```
1. Ir a: learn.microsoft.com/certifications/exams/sc-200
2. Clic en "Schedule exam"
3. Seleccionar Pearson VUE
4. En el pago → aplicar voucher code del AI Skills Fest
5. Fecha límite para usar el voucher: 18 agosto 2026
6. Fecha límite para presentar el examen: 18 octubre 2026
```

---

## Post-Examen

### Si Apruebas ✅
```
- Badge digital en Credly (verificable por empleadores)
- Agregar a LinkedIn con fecha y número de credencial
- Agregar al CV en la sección de certificaciones
- Certificación válida por 2 años → renovar antes de 2028
```

### Si No Apruebas ❌
```
- Retake disponible después de 24 horas
- El voucher NO cubre retake (hay que pagar $165 USD)
- Revisar score report → áreas de mejora
- 2 semanas de repaso enfocado
```

---

*Nota creada el 2026-06-08 | SC-200 Semana 4 — Simulacros y Examen*
