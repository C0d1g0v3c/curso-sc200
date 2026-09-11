---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 11
---
# Honeytoken (cuenta señuelo)

**Definición:** un honeytoken es una cuenta de Active Directory creada específicamente para no tener ningún uso legítimo, configurada y monitoreada de cerca por el equipo de seguridad dentro de [[MDI]].

**Por qué existe:** como nadie legítimo debería tocar nunca esta cuenta, cualquier interacción con ella es por definición sospechosa. Es una forma de generar alertas de altísima confianza (casi sin falsos positivos) sin depender de un modelo de machine learning que tenga que "aprender" qué es normal — aquí no hay comportamiento normal posible.

**Cómo funciona:** el analista crea una cuenta de dominio normal, sin permisos ni uso operativo, y la marca como honeytoken dentro de la configuración de MDI. Si alguien la consulta vía LDAP o SAM-R, intenta autenticarse con ella, o modifica sus atributos o membresía de grupo, MDI genera una alerta. Esa alerta genérica de "Honeytoken activity" se dividió en 5 alertas más específicas (consulta vía SAM-R, consulta vía LDAP, atributos modificados, cambio de membresía de grupo, etc.) para saber de inmediato qué tipo de interacción ocurrió sin abrir la alerta genérica.

**Dónde se configura / rol necesario:** dentro de la configuración de MDI en el portal de Defender (`security.microsoft.com` → Settings → Identities → Entity tags → Honeytoken accounts). Requiere permisos administrativos sobre la configuración de MDI.

**Ejemplo:** un atacante que ya está enumerando el directorio (fase Reconnaissance) consulta por accidente los atributos de la cuenta honeytoken junto con cientos de cuentas reales — esa única consulta dispara una alerta de alta confianza mucho antes de que el atacante llegue a una cuenta real de valor.

**Trampa de examen:** no confundir honeytoken con una "cuenta sensible" (sensitive account) — la cuenta sensible es una cuenta REAL de alto privilegio que SÍ se usa legítimamente y que MDI protege con más atención; el honeytoken es una trampa deliberada sin uso real.

## Lecciones donde aparece
- [[Dia 11 - Identidades Entra ID Protection y MDI]]
