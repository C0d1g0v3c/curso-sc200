---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 9
---
# Contain device

**Definición:** acción de MDE que bloquea las comunicaciones entrantes y salientes de todos los dispositivos onboardeados hacia y desde un dispositivo NO administrado (sin sensor de MDE) que se sospecha comprometido.

**Por qué existe:** un dispositivo sin sensor (IoT, dispositivo de red) no puede aislarse directamente porque Isolate device requiere el sensor de MDE. Contain resuelve el mismo problema "desde afuera", usando a los dispositivos administrados como muro de contención.

**Cómo funciona:** al confirmar la acción, todos los dispositivos onboardeados de MDE bloquean tráfico hacia/desde la IP del dispositivo contenido. El efecto tarda hasta 5 minutos en propagarse. Microsoft recomienda contener como máximo 100 dispositivos a la vez por rendimiento. Existe también "Contain critical assets", una variante granular para activos que no pueden quedar totalmente fuera de línea (controladores de dominio, DNS, DHCP), que solo bloquea puertos/direcciones específicos.

**Dónde se configura / rol necesario:** desde Device inventory o desde la página del dispositivo, botón "Contain device"; requiere Active remediation actions.

**Ejemplo:** un dispositivo IoT sin sensor de MDE se comunica de forma sospechosa con varios equipos administrados; se contiene desde afuera bloqueando esas comunicaciones.

**Trampa de examen:** Contain device es para dispositivos SIN sensor; Isolate device es para dispositivos CON sensor (onboardeados). No son intercambiables.

## Lecciones donde aparece
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]
