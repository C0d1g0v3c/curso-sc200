---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 10
---
# Session policy (MDCA)

**Definición:** política de MDCA (Microsoft Defender for Cloud Apps) que no bloquea el acceso a una aplicación en la nube, sino que monitorea y controla lo que el usuario hace DENTRO de la sesión, en tiempo real (descargas, subidas, copiar/pegar, imprimir). Se distingue de la access policy, que es todo-o-nada al momento del login.

**Por qué existe:** a veces se necesita permitir el acceso a una app pero restringir acciones sensibles específicas (por ejemplo, descargar archivos confidenciales desde un dispositivo no administrado) sin bloquear el uso general de la app.

**Cómo funciona:** depende de Conditional Access App Control, donde MDCA actúa como proxy inverso entre el usuario y la app, interceptando el tráfico. Requiere una política de Conditional Access en Microsoft Entra ID con "Use Conditional Access App Control" habilitado — sin eso, la sesión nunca se redirige al proxy. Las apps de Microsoft Entra se onboardean automáticamente; apps de IdP no-Microsoft requieren onboarding manual. Tipos de control: Monitor only, Block activities, Control file download (with inspection), Control file upload (with inspection); acciones: Audit, Block, Protect (aplica etiqueta de confidencialidad). Si dos políticas entran en conflicto, gana la más restrictiva.

**Dónde se configura / rol necesario:** Cloud apps → Policies → Policy management → pestaña Conditional Access → Create policy → Session policy. Requiere licencia MDCA + Microsoft Entra ID P1.

**Ejemplo:** bloquear la descarga de archivos etiquetados "Altamente confidencial" desde dispositivos no administrados, sin bloquear el resto del acceso a SharePoint.

**Trampa de examen:** session policy (deja pasar, controla) ≠ access policy (todo o nada) ≠ anomaly detection (alerta después del hecho). El calificador "en tiempo real, sin bloquear el resto de la sesión" apunta siempre a session policy.

## Lecciones donde aparece
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]]
