---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 11
---
# Entra ID Protection

**Definición:** Entra ID Protection es una capacidad de Microsoft Entra ID (el directorio de identidades en la nube de Microsoft, antes Azure Active Directory) que usa machine learning para calcular, en tiempo real y de forma continua, qué tan probable es que una cuenta o un inicio de sesión (sign-in) estén comprometidos. No es un producto aparte que se instala: se activa sobre el directorio que ya existe, y su salida son **risk detections** (detecciones de riesgo) que alimentan dos reportes (Risky users, Risky sign-ins) y pueden disparar remediación automática vía Conditional Access.

**Por qué existe:** un atacante con una contraseña o un token robado no necesita malware para entrar — inicia sesión como si fuera el usuario legítimo. Un antivirus o firewall no ve nada anómalo porque no hay archivo ni tráfico malicioso que detectar. Entra ID Protection resuelve ese punto ciego: analiza patrones de comportamiento (ubicación habitual, dispositivo, hora, si la contraseña apareció en una fuga de datos) para detectar cuándo un inicio de sesión legítimo en apariencia en realidad no lo es.

**Cómo funciona:** cada sign-in y cada estado de cuenta se evalúan contra un modelo de ML que produce un `riskEventType` (el tipo exacto de detección) y un `riskLevel` (Low/Medium/High). Algunas detecciones se calculan en tiempo real (5-10 min, ej. Unfamiliar sign-in properties) y pueden bloquear el acceso en el momento vía Conditional Access; otras se calculan offline (hasta 48h, ej. Impossible travel) porque necesitan correlacionar más señal, y solo permiten actuar retroactivamente. Las detecciones Low se "envejecen" automáticamente a los 6 meses si nadie las remedia; Medium y High persisten indefinidamente.

**Dónde se configura / rol necesario:** `entra.microsoft.com` → **Protection → Identity Protection** para ver los reportes Risky users / Risky sign-ins. La remediación automática se configura como una **Conditional Access policy** (Protection → Conditional Access → New policy) con condición de User risk o Sign-in risk — el panel clásico de Identity Protection → Policies se retira el 1-oct-2026. Requiere licencia **Microsoft Entra ID P2** para el catálogo completo de detecciones (con Free/P1 se recibe la versión genérica "Additional risk detected"). Administrar políticas requiere rol Conditional Access Administrator o Security Administrator/Global Administrator.

**Ejemplo:** un usuario inicia sesión desde una IP marcada como anónima (Tor) — detección en tiempo real, sign-in risk Medium. Una Conditional Access policy con condición Sign-in risk ≥ Medium le exige completar MFA en el momento; si la completa, el sign-in se permite y el riesgo se remedia solo.

**Trampa de examen:** el examen distingue con mucho cuidado "risky sign-ins" (evento puntual) de "risky users" (estado agregado de la cuenta) — ver [[Riesgo de usuario vs riesgo de sign-in]]. Otra trampa: las políticas de riesgo legacy del panel clásico se retiran el 1-oct-2026, dos días antes del examen de este alumno; la respuesta vigente siempre es Conditional Access.

## Lecciones donde aparece
- [[Dia 11 - Identidades Entra ID Protection y MDI]]
