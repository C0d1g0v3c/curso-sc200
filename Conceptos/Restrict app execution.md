---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 9
---
# Restrict app execution

**Definición:** acción de MDE que aplica una política de integridad de código a un dispositivo, permitiendo ejecutar únicamente archivos firmados por Microsoft.

**Por qué existe:** a veces se necesita impedir que un atacante ejecute herramientas nuevas en un dispositivo comprometido, pero sin llegar al extremo de cortar toda su conectividad de red (lo que sí hace Isolate device).

**Cómo funciona:** aplica una política de integridad de código (Windows Defender Application Control) que bloquea la ejecución de cualquier binario no firmado por Microsoft. Es reversible con el botón "Remove app restrictions". Requiere Windows 10 1709+/Windows 11/Windows Server 2019+ y que el dispositivo use Microsoft Defender Antivirus. Muestra una notificación al usuario final (excepto en Windows Server 2016/2012 R2).

**Dónde se configura / rol necesario:** botón en la página del dispositivo; requiere Active remediation actions.

**Ejemplo:** un dispositivo con múltiples binarios sospechosos recién descargados se restringe para impedir que se ejecute cualquier programa nuevo, mientras el resto de su actividad de red (correo, navegación) sigue funcionando.

**Trampa de examen:** no corta la red — es más quirúrgico que Isolate device. Si el enunciado pide impedir ejecución de programas SIN cortar la red completa, esta es la respuesta.

## Lecciones donde aparece
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]
