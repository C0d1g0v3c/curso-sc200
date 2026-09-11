---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 9
---
# Collect investigation package

**Definición:** acción de MDE que descarga un .zip con el estado actual de un dispositivo (procesos, autoruns, conexiones de red, logs de seguridad, etc.), pensado para entender qué herramientas y técnicas usó un atacante, sin ejecutar nada ni alterar la conectividad del dispositivo.

**Por qué existe:** a veces se necesita evidencia forense completa sin alertar al atacante, sin interrumpir a un usuario activo, ni arriesgar un impacto innecesario por un posible falso positivo — algo que Isolate device sí causaría.

**Cómo funciona:** al confirmar la acción (con comentario obligatorio) el sensor de MDE ejecuta comandos de recolección locales y sube el resultado al Action center, desde donde se descarga. Puede fallar si el dispositivo tiene batería baja o conexión medida. Contenido en Windows: Autoruns, Installed programs, Network connections, Prefetch files, Processes, Scheduled tasks, Security event log, Services, sesiones SMB, System Information, Temp Directories, Users and Groups, WdSupportLogs y un CollectionSummaryReport.xls. En macOS/Linux: apps instaladas, disco, archivos abiertos, historial de shell/login, módulos de kernel, red, sudoers, y en macOS también integridad EFI y estado SIP.

**Dónde se configura / rol necesario:** botón en la barra de acciones de la página del dispositivo. Requiere el permiso "Alerts investigation" — NO requiere Active remediation actions.

**Ejemplo:** en el dispositivo de un ejecutivo en llamada, el analista recolecta el paquete para revisar procesos y conexiones sin cortar su red, evitando impacto si resulta falso positivo.

**Trampa de examen:** no aísla el dispositivo ni corta su red. Si el enunciado pide "minimizar impacto" o "sin cortar la red", casi siempre es esta acción y no Isolate device.

## Lecciones donde aparece
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]
