---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# SOC optimization

**Definición:** funcionalidad de Microsoft Sentinel que analiza automáticamente el workspace y entrega recomendaciones accionables de cuatro tipos: data value, coverage-based (threat-based, AI MITRE ATT&CK tagging, risk-based) y similar organizations.

**Por qué existe:** sin esta herramienta, cerrar huecos de cobertura y abaratar ingesta que no aporta valor de seguridad exigiría que un ingeniero revisara manualmente tabla por tabla y regla por regla.

**Cómo funciona:** data value mira tablas facturables con ingesta en los últimos 30 días y sugiere activar detecciones o abaratar/eliminar la tabla (salvo si la usa UEBA o threat intel matching, ahí no toca nada); threat-based compara logs y reglas contra lo necesario para cubrir ataques conocidos; AI MITRE tagging (preview) etiqueta detecciones sin táctica/técnica con IA; risk-based (preview) razona desde el daño de negocio (operacional, financiero, reputacional, cumplimiento, legal); similar organizations usa machine learning para sugerir fuentes que usan organizaciones parecidas (más frecuente en SOC en onboarding).

**Dónde se configura / rol necesario:** Microsoft Sentinel > SOC optimization. Ver con Microsoft Sentinel Reader; aplicar una recomendación requiere el rol correspondiente a esa acción (p. ej. Contributor para activar plantillas).

**Ejemplo:** SOC optimization detecta que tienes Entra ID Protection conectado pero ninguna analytics rule de "impossible travel" activa — es una recomendación threat-based.

**Trampa de examen:** threat-based razona desde el ataque; risk-based razona desde el daño de negocio. Data value nunca toca tablas usadas por UEBA o threat intel matching.

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
