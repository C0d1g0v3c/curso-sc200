---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 9
---
# Isolate device

**Definición:** acción de MDE que desconecta a un dispositivo onboardeado (con sensor de MDE) de la red, manteniendo su conexión con el servicio de MDE para poder seguir monitoreándolo y gestionándolo.

**Por qué existe:** cuando un dispositivo comprometido representa alto riesgo de propagación (movimiento lateral, exfiltración), hay que cortar su capacidad de comunicarse con el resto de la red sin perder visibilidad sobre él.

**Cómo funciona:** tiene dos modos — aislamiento completo (corta todo salvo la comunicación con MDE) y aislamiento selectivo (permite excepciones configurables, como Outlook/Teams o procesos y destinos específicos vía isolation exclusions). Si el dispositivo está offline al enviar la orden, MDE reintenta aplicarla hasta 3 días. La desisolación es automática a los 7 días si nadie la libera antes. También existe la variante automática "Isolate device — automatic attack disruption (preview)".

**Dónde se configura / rol necesario:** botón en la página del dispositivo; requiere el permiso "Active remediation actions" y acceso al dispositivo vía device groups.

**Ejemplo:** un dispositivo onboardeado con alta confianza de compromiso y riesgo de propagación se aísla de inmediato para cortar cualquier movimiento lateral.

**Trampa de examen:** solo aplica a dispositivos ONBOARDEADOS (con sensor). Para dispositivos sin sensor, la acción correcta es Contain device, no Isolate device.

## Lecciones donde aparece
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]
