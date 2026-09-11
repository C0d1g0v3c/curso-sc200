---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 11
---
# Riesgo de usuario vs riesgo de sign-in

**Definición:** dentro de [[Entra ID Protection]], **sign-in risk** es la probabilidad de que UN inicio de sesión puntual no lo haya hecho el dueño legítimo de la cuenta — es un evento, cada sign-in tiene su propio cálculo, independiente de los demás. **User risk** es la probabilidad de que LA CUENTA en sí esté comprometida, acumulando evidencia de varios sign-ins y señales a lo largo del tiempo — no es un evento puntual, es un estado que persiste hasta que se remedia.

**Por qué existe la distinción:** un solo sign-in raro (ej. viajar y conectarse desde un país nuevo) puede ser inocente y no implica que la cuenta completa esté comprometida. Pero varias señales de riesgo acumuladas sobre la misma cuenta (leaked credentials + AiTM + actividad administrativa atípica) sí justifican tratar la cuenta entera como comprometida. Separar ambos ejes evita sobre-reaccionar a un evento aislado y a la vez permite escalar cuando el patrón es sostenido.

**Cómo funciona:** cada detección de riesgo se clasifica de fábrica como detección de sign-in risk o de user risk (nunca ambas). Ejemplos de sign-in risk: Anonymous IP address, Anomalous token, Impossible travel, Password spray. Ejemplos de user risk: Leaked credentials, Attacker in the Middle, Anomalous user activity, Suspicious API traffic. El nivel de riesgo (Low/Medium/High) se calcula igual para ambos ejes.

**Dónde se configura / rol necesario:** dos reportes separados en `entra.microsoft.com` → Protection → Identity Protection: **Risky sign-ins report** (una fila por evento) y **Risky users report** (una fila por usuario, con su nivel agregado). La remediación se configura como dos políticas de Conditional Access separadas — **nunca combinar ambas condiciones en la misma política**, Microsoft lo marca como advertencia explícita porque no funcionan como se espera si se combinan.

**Ejemplo:** "dame la lista de usuarios con riesgo Alto sin remediar ahora mismo, para priorizar a quién llamamos" → Risky users report (estado agregado). "Dame cada inicio de sesión riesgoso de Juan en las últimas 24h con IP y ubicación" → Risky sign-ins report (evento por evento).

**Trampa de examen:** el calificador del enunciado decide. "Evento puntual", "en las últimas X horas", "cada inicio de sesión" → sign-in risk / Risky sign-ins. "Qué cuentas siguen en riesgo", "estado actual de la cuenta", "sostenido en el tiempo" → user risk / Risky users. Este ítem ya costó puntos en el Simulacro 01 del 23-jul-2026 — es el error más repetido de este bloque.

## Lecciones donde aparece
- [[Dia 11 - Identidades Entra ID Protection y MDI]]
