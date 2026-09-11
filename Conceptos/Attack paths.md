---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 11
---
# Attack paths (antes Lateral Movement Paths)

**Definición:** capacidad de [[MDI]] que identifica y visualiza, como un grafo, las rutas que un atacante podría usar para moverse lateralmente desde una cuenta de bajo privilegio hasta una cuenta sensible (administradores de dominio, cuentas de servicio críticas). Se llamaba **Lateral Movement Paths (LMPs)** en el portal clásico de MDI, ya retirado; en el portal unificado de Defender vive en la pestaña **Attack paths** dentro de la página de Identidad de cada entidad.

**Por qué existe:** conocer qué vulnerabilidades existen no basta; lo que importa para priorizar remediación es saber si esa vulnerabilidad conecta con algo crítico. Un equipo mal configurado es un riesgo bajo si nadie con privilegios altos inicia sesión ahí; es un riesgo altísimo si un administrador de dominio comparte credenciales en esa misma máquina. Attack paths hace visible esa conexión antes de que un atacante la explote.

**Cómo funciona:** MDI analiza credenciales compartidas entre máquinas, membresías de grupo, y permisos administrativos innecesarios, y construye un grafo de "quién puede llegar a quién". El resultado es una capacidad de **postura** (encontrar el camino antes del ataque), distinta de las alertas de MDI (que detectan el ataque ya en curso).

**Dónde se configura / rol necesario:** portal de Defender (`security.microsoft.com`), página de Identidad de la entidad afectada, pestaña **Attack paths**. Solo lectura/investigación — no requiere un rol especial más allá del acceso estándar de analista al portal de Defender.

**Ejemplo:** Attack paths muestra que una cuenta de servicio de bajo privilegio tiene una sesión guardada en un equipo donde también inició sesión un administrador de dominio — si el atacante compromete la cuenta de servicio, puede robar el hash o ticket del administrador desde esa misma máquina (Pass-the-Hash / Pass-the-Ticket).

**Trampa de examen:** si el examen usa el nombre "Lateral Movement Path", reconoce que describe el mismo concepto que hoy se llama Attack paths — es terminología del portal clásico, ya archivado. No confundir con la Identity Timeline, que muestra actividad cronológica de UNA cuenta, no rutas de escalamiento entre cuentas.

## Lecciones donde aparece
- [[Dia 11 - Identidades Entra ID Protection y MDI]]
