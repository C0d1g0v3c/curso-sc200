---
tags: [sc-200, sentinel, leccion-diaria]
dia: 1
fecha: 2026-07-06
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
estado: ✅ Completada
cover: ""
---

# Lección Día 1 — Arquitectura de Microsoft Sentinel + Tiers de Retención

> [!info] Contexto
> El plan de [[GUIA_INTENSIVA_24_DIAS]] arranca oficialmente el lunes 7-jul-2026; esta lección se completó el 6-jul, así que voy **un día adelantado**. Progreso registrado en [[TRACKER_TUTOR]].

> [!warning] Nota desactualizada
> [[Modulo_4_Unified_SecOps_Exposure]] §8.1 usa términos "Basic/Auxiliary logs" que **ya no existen**. Esta lección está verificada contra Microsoft Learn (jul-2026).

## 📖 Lectura

### Conceptos base (antes de hablar de Sentinel)

- **Log**: registro que deja cualquier sistema cuando pasa algo — un inicio de sesión, un proceso que se ejecuta, un correo que llega. Es la materia prima de toda la seguridad defensiva.
- **SIEM** (*Security Information and Event Management*): plataforma que **recolecta los logs de todas las fuentes** de una organización (servidores, firewalls, nube, correo, identidad) en un solo lugar, los **correlaciona** (cruza eventos de fuentes distintas para detectar patrones sospechosos) y **genera alertas**. Sin SIEM, cada log vive aislado en su sistema y nadie ve el ataque completo.
- **SOAR** (*Security Orchestration, Automation and Response*): capa que **automatiza la respuesta** a esas alertas — por ejemplo: si llega una alerta de phishing, automáticamente aislar el equipo, bloquear al remitente y avisar por Teams, sin que un humano haga cada paso a mano.
- **Cloud-native**: el servicio corre en la nube del proveedor; no instalas ni mantienes servidores propios, y escala solo según cuántos datos le mandes.

### Qué es Microsoft Sentinel

Sentinel es el **SIEM + SOAR cloud-native de Microsoft** (corre en Azure). Sus piezas fundamentales:

- **Log Analytics workspace**: la **base de datos** donde caen todos los logs que Sentinel recolecta. Todo Sentinel se construye encima de un workspace — cuando "habilitas Sentinel", lo que haces es activarlo sobre un workspace.
- **Tablas**: dentro del workspace, cada tipo de dato vive en su propia tabla con sus propias columnas. Ejemplos: `SigninLogs` (inicios de sesión de Entra ID), `DeviceProcessEvents` (procesos ejecutados en endpoints), `CommonSecurityLog` (logs de firewalls y appliances en formato estándar CEF, *Common Event Format*).
- **KQL** (*Kusto Query Language*): el lenguaje con el que consultas esas tablas — el equivalente a SQL pero para logs. Es la herramienta #1 del examen y del trabajo real.
- **ASIM** (*Advanced Security Information Model*): como cada tabla tiene columnas distintas (en una la IP se llama `IPAddress`, en otra `SrcIP`), ASIM es un conjunto de **funciones de normalización opcionales** que traducen tablas distintas a un esquema común, para escribir una sola query que funcione sobre varias fuentes.

### Los cuatro pilares de Sentinel

1. **Collect (recolectar)** — los **conectores de datos** traen logs de cada fuente al workspace. Los hay integrados (un clic para servicios de Microsoft), basados en agente (**AMA**, *Azure Monitor Agent*, instalado en máquinas, con **DCR**, *Data Collection Rules*, que definen qué recolecta), por API, o construidos sin código (**Codeless Connector Platform**).
2. **Detect (detectar)** — las **analytics rules** son las reglas de detección: queries KQL que corren sobre los datos y generan alertas. Tipos: *Scheduled* (corren cada X minutos), *NRT* (near-real-time, casi en tiempo real), *Microsoft Security* (promueven alertas de otros productos Defender), *Fusion/ML* (correlación con machine learning), *Threat Intelligence* y *Anomalías*.
3. **Investigate (investigar)** — las alertas relacionadas se agrupan en **incidents** (casos de investigación), con un **investigation graph** que dibuja visualmente las **entidades** involucradas (usuarios, IPs, equipos) y sus conexiones.
4. **Respond (responder)** — la parte SOAR: **automation rules** (condiciones tipo "si el incident es de severidad alta, asígnalo a X y ejecuta Y") y **playbooks** (flujos de automatización construidos con **Logic Apps**, el servicio de workflows de Azure: aislar equipo, bloquear usuario, mandar notificación, etc.).

Todo vive hoy en el **portal unificado de Defender** (Unified SecOps) — ya no hay dos portales separados.

### El modelo de tiers de datos (lo más examinado)

**El problema que resuelve:** guardar logs **cuesta dinero**, y Microsoft cobra según qué tan disponible esté el dato. Una empresa genera gigas de logs al día y no puede borrarlos (hay leyes que obligan a conservarlos años), pero tampoco puede pagar por tenerlos todos en modo instantáneo. La solución: dos niveles de almacenamiento (*tiers*).

**Analogía: tu escritorio vs una bodega.**

**1. Analytics tier = el escritorio (datos "calientes")**
- Lo que está aquí se usa **al instante**: las analytics rules (que corren cada pocos minutos buscando ataques) y los **workbooks** (los dashboards/reportes interactivos de Sentinel) solo funcionan con datos de este nivel.
- El espacio de escritorio es caro → los datos viven aquí **90 días** por defecto, extensible pagando hasta **2 años**.

**2. Data lake tier = la bodega (datos "fríos")**
- Cajas archivadas: barato y cabe muchísimo — hasta **12 años**.
- **No se consulta al instante.** Para buscar algo lanzas un **KQL job**: le encargas la búsqueda y el resultado llega después (como pedir que te traigan una caja de la bodega). También se puede explorar con **notebooks** (cuadernos interactivos tipo Jupyter para análisis avanzado).
- Si lo que encuentras resulta importante (p. ej. evidencia de un ataque viejo), lo **promueves**: lo copias de vuelta al tier Analytics para investigarlo activamente.

**El espejo automático:** cada dato que entra al escritorio deja automáticamente una copia en la bodega, durante la misma ventana de retención. Cuando expiran sus 90 días de Analytics, el dato no se pierde — sigue en el data lake si configuraste que viva más tiempo ahí.

**¿Y el "XDR standalone"?** No es un tercer tier: es lo que pasa si una empresa tiene **solo Defender XDR (Extended Detection and Response) sin conectar Sentinel**. Sus datos solo viven **30 días** en **Advanced Hunting** (la consola de consultas KQL del portal de Defender). Conectar Sentinel es lo que desbloquea los dos tiers de arriba.

Tabla resumen:

| Tier                     | Retención                                    | Consulta                                                                      | Costo    | Uso                                       |
| ------------------------ | -------------------------------------------- | ----------------------------------------------------------------------------- | -------- | ----------------------------------------- |
| **Analytics** (caliente) | 90 días por defecto, extensible a **2 años** | KQL en tiempo real, alimenta analytics rules y workbooks                      | Alto     | Alertas y dashboards en vivo              |
| **Data lake** (frío)     | Hasta **12 años**                            | **KQL jobs** o notebooks (no tiempo real); resultados promovibles a Analytics | Bajo     | Compliance, auditorías, hunting histórico |
| **XDR standalone**       | **30 días** (Advanced Hunting sin Sentinel)  | Advanced Hunting                                                              | Incluido | Solo Defender XDR sin workspace           |

Comportamiento por defecto: **todo lo que entra a Analytics se espeja automáticamente al data lake** durante la misma ventana de retención interactiva.

**La pregunta que decide todo:** *¿alguien necesita este dato al instante?*
- **Sí** (alimenta alertas o dashboards en vivo) → **Analytics** (escritorio).
- **No** (solo por ley, auditorías o búsquedas históricas ocasionales) → **Data lake** (bodega).

> [!tip] Truco de examen
> "Retener X años, consulta ocasional, minimizar costo" → casi siempre **Data lake tier**. La trampa clásica es ofrecer "exportar a **Storage Account**" (el almacén genérico de archivos de Azure): suena barato, pero ahí el dato ya **no se puede consultar con KQL desde Sentinel** — casi nunca es la respuesta. Extender Analytics tampoco: es el tier caro.

## 💡 Ejemplos

**1 — Tipo examen (elección de tier)**
"Conservar `CommonSecurityLog` (logs del firewall) 5 años por regulación; solo se consultan en la auditoría anual; minimizar costo."
Razonamiento: ¿alguien lo necesita al instante? No — solo una vez al año. → **Data lake tier** (bodega) con retención extendida a 5 años.

**2 — KQL para decidir qué mandar a la bodega**
Antes de mover tablas de tier necesitas saber cuáles son las caras (las que más GB ingieren). El propio workspace lleva esa contabilidad en una tabla llamada `Usage`:

```kql
Usage
| where TimeGenerated > ago(30d)
| where IsBillable == true
| summarize TotalGB = round(sum(Quantity) / 1000, 2) by DataType
| order by TotalGB desc
| take 15
```

Línea por línea:
- `Usage` — la tabla que registra cuánto dato entró al workspace.
- `| where TimeGenerated > ago(30d)` — filtra: solo los últimos 30 días (`ago(30d)` = "hace 30 días").
- `| where IsBillable == true` — solo el dato que Microsoft cobra.
- `| summarize TotalGB = ... by DataType` — suma la cantidad ingerida **agrupando por tabla** (`DataType` = nombre de la tabla) y la convierte a GB redondeados a 2 decimales.
- `| order by TotalGB desc` — ordena de mayor a menor.
- `| take 15` — muestra solo las 15 primeras.

Interpretación: si una tabla pesa mucho pero solo se usa para compliance o búsquedas esporádicas → candidata a Data lake. Si alimenta analytics rules activas, se queda en Analytics aunque pese.

**3 — Arquitectura (Unified SecOps)**
"Una empresa tiene solo Defender XDR (sin Sentinel) y se queja de que solo puede investigar 30 días atrás. Quiere `DeviceProcessEvents` 2 años, *consultándolo activamente* cuando surja un caso legal."
Razonamiento: primero hay que **conectar un workspace de Sentinel** (sin eso, nada vive más de 30 días). Y como dice "consultándolo activamente" = lo necesita al instante → **Analytics tier extendido a 2 años**, no data lake.

## 🎥 Recursos

1. [Preparing for SC-200: Manage a security operations environment (Part 1 of 4)](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/preparing-for-sc-200-manage-a-security-operations-environment) — Exam Readiness Zone oficial, ~20-25 min.
2. [Microsoft Sentinel Data Lake — Overview & Demo](https://www.youtube.com/watch?v=MxxOR2gCSag) — demo de la UI (grabada en preview, conceptos vigentes).
3. [Manage data tiers and retention in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/manage-data-overview) — fuente primaria en Microsoft Learn.

## 🧪 Ejercicio práctico

> [!warning] Lab corregido (6-jul-2026)
> El **Sentinel Training Lab** del Marketplace que se recomendaba aquí está **abandonado desde enero 2024** (anterior al portal unificado de Defender y al modelo de data lake): sus capturas y pasos ya no coinciden con la realidad. En su lugar, usar los **labs oficiales del curso SC-200**, actualizados el 29-jun-2026 con simulaciones interactivas (algunas ni requieren tenant propio): [SC-200T00A — instrucciones](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/) · [repo en GitHub](https://github.com/MicrosoftLearning/SC-200T00A-Microsoft-Security-Operations-Analyst).

- [x] Cuenta **Azure free** ($200 crédito / 30 días).
- [x] Crear **Log Analytics workspace** + habilitar **Sentinel** (31 días de evaluación gratis).
- [x] Completar el **[Lab 6, Ex 1 — Configure your Microsoft Sentinel environment](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_06_Lab1_Ex01_Deploy_Sentinel_Defender.html)** (workspace + Sentinel + portal Defender — exactamente lo de hoy). Usar siempre las versiones "Defender" de los labs, no las variantes "Azure" (portal viejo).
- [x] En Settings > **Tables** del workspace, localizar la columna **Table plan** e identificar el tier de 2 tablas. *(Resultado: solo existía `Watchlist` → plan Analytics — las tablas nacen cuando llegan datos.)*
- [ ] Correr la query del Ejemplo 2 (`Usage`) contra el workspace.

## ✅ Quiz del día

**P1.** Retener logs IoT 8 años por normativa, consulta solo en auditoría. ¿Tier?
A) Data lake · B) Analytics extendido · C) Storage Account · D) Basic logs

**P2.** Retención interactiva por defecto del tier Analytics:
A) 30 días · B) 180 días · C) 90 días · D) 12 años

**P3.** ¿Un dato en Data lake se consulta con dashboard en tiempo real?
A) Sí · B) Solo si tiene menos de 30 días · C) Solo vía Power BI · D) No — se usa KQL jobs/notebooks, con promoción posible a Analytics

**P4.** XDR sin Sentinel: ¿retención por defecto de Advanced Hunting?
A) 30 días · B) 7 días · C) 90 días · D) 12 años

**P5.** ¿Qué pasa por defecto con un dato que entra a Analytics respecto al Data lake?
A) Nada · B) Se borra al expirar · C) Se espeja automáticamente durante la misma ventana · D) Requiere una automation rule

### Respuestas explicadas

> [!note]- Ver respuestas (spoiler)
> **P1 — A.** Data lake: retención larga (hasta 12 años) a bajo costo, consulta ocasional vía KQL jobs. Storage Account (C) pierde la consulta KQL nativa.
> **P2 — C.** 90 días, extensible hasta 2 años. El número que más preguntan de memoria.
> **P3 — D.** El data lake no es tiempo real: KQL jobs o notebooks, con promoción a Analytics si hay que investigar activamente.
> **P4 — A.** 30 días es el default de Advanced Hunting sin workspace de Sentinel vinculado.
> **P5 — C.** El espejado Analytics → Data lake es comportamiento por defecto, no requiere automation rule (eso es para incidents).

---

*Relacionadas: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[01_Semana1_Sentinel_Fundamentos]] · [[Chronicle_vs_Sentinel]] · [[CHEATSHEET_KQL]]*
