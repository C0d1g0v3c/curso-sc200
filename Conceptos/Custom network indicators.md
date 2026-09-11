---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# Custom network indicators

**Definicion:** Advanced feature de MDE que permite crear indicadores personalizados de IP, dominio o URL (Allow/Block) aplicados a nivel de red en todos los endpoints onboardeados.

**Por que existe:** Permite bloquear infraestructura de comando y control (C2) en todos los dispositivos de inmediato, sin esperar a que exista firma de antivirus para el malware asociado.

**Como funciona:** Activado el interruptor, un analista crea el indicador en Settings > Endpoints > Indicators con accion Allow o Block; la politica se distribuye a todos los dispositivos onboardeados via network protection.

**Donde se configura / rol necesario:** Interruptor en Advanced features; indicadores en Settings > Endpoints > Indicators. Requiere Security Administrator. Dispositivos: Windows 10 1709+ o Windows 11.

**Ejemplo:** Threat intelligence confirma un dominio de C2; se crea un indicador de bloqueo y en minutos ningun endpoint onboardeado puede comunicarse con el.

**Trampa de examen:** No confundir con ASR rules (comportamiento de software local); custom network indicators opera sobre destinos de red especificos.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
