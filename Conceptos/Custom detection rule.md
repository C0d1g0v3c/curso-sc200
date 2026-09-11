---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
dia_origen: 15
---
# Custom detection rule

**Definición:** una query de Advanced Hunting convertida en una regla que corre sola a intervalos fijos, genera una alerta cuando encuentra coincidencias, y opcionalmente ejecuta una acción de respuesta automatizada (aislar dispositivo, poner en cuarentena un archivo, deshabilitar un usuario, mover un correo).

**Por qué existe:** correr una query manualmente sirve para investigar un incidente puntual, pero no escala para monitoreo continuo. Es el equivalente, del lado de Advanced Hunting, de las Scheduled analytics rules de Sentinel — con la diferencia de que puede combinar datos de Defender XDR y de Sentinel en la misma query.

**Cómo funciona:** seis pasos — preparar la query (con `Timestamp`/`ReportId`/`DeviceId` u otro identificador fuerte de entidad; límite de 150 alertas por corrida), crear la regla y sus alert details (nombre, frecuencia, severidad, MITRE ATT&CK), enriquecimiento (título/descripción dinámicos, custom details, entity mapping), especificar acciones (cada acción exige una columna específica en el resultado), definir el scope (dispositivos), y revisar/activar. Frecuencias: cada 24h/12h/3h/1h (lookback fijo si usa datos de Defender XDR), Continuous NRT (una sola tabla, sin join/union/comentarios), o Custom (solo si es 100% datos de Sentinel, con reglas de lookback según qué tan frecuente sea la corrida).

**Dónde se configura / rol necesario:** desde Advanced Hunting (Create detection rule) o desde la lista de Custom detection rules. Permisos: Security settings (manage) o Security Administrator (Entra) para datos de Defender; Microsoft Sentinel Contributor o superior para datos de Sentinel; ambos si la regla combina datos de los dos.

**Ejemplo:**
```kql
DeviceEvents
| where ingestion_time() > ago(1d)
| where ActionType == "AntivirusDetection"
| summarize (Timestamp, ReportId) = arg_max(Timestamp, ReportId), count() by DeviceId
| where count_ > 5
```

**Trampa de examen:** la disponibilidad de cada acción automatizada depende únicamente de qué columnas devuelve la query, no de la intención del analista — sin `DeviceId` proyectado, "Isolate device" no está disponible aunque el escenario lo pida. Y una query con `union`/`join` nunca es elegible para Continuous (NRT), sin importar qué tan simple sea el resto.

## Lecciones donde aparece
- [[Dia 15 - Repaso KQL Advanced Hunting Custom Detections y Hunting Graph]]
