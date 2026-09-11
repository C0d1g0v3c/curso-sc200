---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 10
---
# ZAP (Zero-hour Auto Purge)

**Definición:** mecanismo automático de MDO (Microsoft Defender for Office 365) que detecta y neutraliza retroactivamente mensajes de phishing, spam o malware que ya fueron entregados a un buzón en la nube — sin intervención de un analista.

**Por qué existe:** el filtrado en el momento de la entrega no es perfecto (malware de día cero, enlaces que se "arman" después de entregados). ZAP monitorea continuamente firmas de amenazas y actúa sobre mensajes que ya están en el buzón del usuario.

**Cómo funciona:** busca en las últimas 48 horas de correo entregado. Para Malware y High confidence phishing, siempre pone el mensaje en cuarentena. Para Phishing (no high-confidence) y Spam/High confidence spam, el resultado depende de la acción configurada en la política anti-spam (Move to Junk, Quarantine, o ninguna acción si la política dice Delete/Add X-Header/etc.). No notifica al usuario. Cubre también la carpeta Elementos eliminados y, desde enero de 2026, mensajes de Teams (chats y canales) identificados como malware o high-confidence phishing — esto último requiere licencia MDO Plan 1 o 2; el resto de ZAP (correo) no requiere licencia especial. Se verifica vía Threat Explorer (columna "Additional action" = ZAP) o en Advanced Hunting, tabla EmailPostDeliveryEvents con ActionType "Phish ZAP" / "Malware ZAP".

**Dónde se configura / rol necesario:** no se "dispara" — corre automáticamente según las políticas anti-spam/anti-malware/anti-phishing ya configuradas. No hay rol para activarlo manualmente sobre un mensaje puntual.

**Ejemplo:** un mensaje de phishing llega sin ser detectado; 6 horas después una nueva firma lo identifica y, según la política vigente ("Move to Junk"), ZAP lo mueve automáticamente a Correo no deseado.

**Trampa de examen:** ZAP es automático; Threat Explorer es manual. Si el enunciado dice "sin intervención de un analista" → ZAP; si dice "un analista investigó y decidió" → Threat Explorer.

## Lecciones donde aparece
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]]
