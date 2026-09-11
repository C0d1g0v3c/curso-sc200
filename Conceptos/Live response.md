---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# Live response

**Definicion:** Consola de respuesta remota en vivo sobre dispositivos onboardeados a MDE, que permite ejecutar comandos, recolectar archivos y correr scripts directamente sobre el endpoint en tiempo real.

**Por que existe:** Permite a un analista investigar o remediar activamente un dispositivo comprometido sin esperar a un ciclo de politicas ni desplazarse fisicamente.

**Como funciona:** Existen tres interruptores separados: Enable live response (estaciones de trabajo), Enable live response for servers, y Allow unsigned script execution in live response (desactivado por defecto). Ademas del interruptor de tenant, el analista necesita un rol con permiso de Live response.

**Donde se configura / rol necesario:** Settings > Endpoints > Advanced features (los tres interruptores) y Settings > Endpoints > Roles (permiso Basic o Advanced). Requiere Security Administrator para configurar; el analista necesita el rol de Live response asignado.

**Ejemplo:** Un analista sube y ejecuta un script propio de triage durante una sesion de live response, lo cual requiere que "Allow unsigned script execution" este activo.

**Trampa de examen:** Un analista no puede correr su propio script aunque tenga el rol correcto si falta activar "Allow unsigned script execution", un interruptor distinto del interruptor general de live response.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
