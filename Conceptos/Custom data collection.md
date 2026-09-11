---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# Custom data collection

**Definicion:** Capacidad de MDE (todavia prerelease a sep-2026) que permite definir reglas de recoleccion personalizadas con filtros sobre propiedades de evento (rutas de carpeta, nombres de proceso, conexiones de red), para obtener telemetria mas especifica que la que viene por defecto.

**Por que existe:** La telemetria por defecto de MDE es enorme pero generica; casos como threat hunting dirigido, monitoreo de apps propias o evidencia de compliance necesitan visibilidad muy especifica sin el costo/ruido de ingerir todo.

**Como funciona:** 5 pasos: definir reglas con filtros, targetear dispositivos con dynamic tags (prerequisito obligatorio, configuradas primero en Asset Rule Management), desplegar (20 min a 1h), recolectar eventos (se suman a la telemetria estandar, no la reemplazan), y analizar en el workspace de Sentinel conectado (obligatorio). Los eventos van a 5 tablas: DeviceCustomProcessEvents, DeviceCustomImageLoadEvents, DeviceCustomFileEvents, DeviceCustomNetworkEvents, DeviceCustomScriptEvents. Limite: 75,000 eventos por regla por dispositivo cada 24h.

**Donde se configura / rol necesario:** Settings > Endpoints > Custom data collection. Requiere Security Administrator y un workspace de Sentinel conectado.

**Ejemplo:** Recolectar todo acceso a archivos de una app financiera en 40 servidores especificos usando una dynamic tag que los identifique.

**Trampa de examen:** El prerequisito real antes de crear la regla es la dynamic tag en Asset Rule Management, no una automation rule ni un playbook.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
