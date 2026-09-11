---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 12
---
# JIT VM access (Just-in-Time VM access)

**Definición:** JIT (Just-In-Time) VM access es una capacidad de [[Defender for Servers Plan 1 vs Plan 2|Defender for Servers Plan 2]] que mantiene cerrados por defecto los puertos de administración remota de una VM (RDP 3389, SSH 22) y solo los abre bajo demanda, por un tiempo limitado, cuando un administrador lo solicita explícitamente.

**Por qué existe:** los puertos de administración remota abiertos permanentemente son uno de los vectores de ataque más comunes contra VMs expuestas a internet (fuerza bruta contra RDP/SSH). JIT reduce esa superficie de ataque sin sacrificar la capacidad de administrar la VM cuando realmente hace falta.

**Cómo funciona:** el administrador solicita acceso desde el portal (o vía API/CLI), especificando por cuánto tiempo y desde qué rango de IP necesita el puerto abierto. Defender for Cloud ajusta temporalmente las reglas de Network Security Group (NSG) para permitir ese tráfico solo durante la ventana solicitada, y las revierte automáticamente al expirar.

**Dónde se configura / rol necesario:** `portal.azure.com` → Defender for Cloud → Workload protections → **Just-in-time VM access**, o directamente desde la página de la VM. Requiere Defender for Servers **Plan 2** habilitado sobre la suscripción, y permisos de red (Network Contributor o equivalente) para modificar las reglas del NSG.

**Ejemplo:** un administrador necesita conectarse por RDP a una VM de producción para aplicar un parche urgente — solicita JIT por 1 hora desde su IP actual; pasada esa hora, el puerto vuelve a cerrarse automáticamente sin intervención manual.

**Trampa de examen:** JIT VM access **no está disponible para GCP**, solo Azure y AWS — si el enunciado menciona una VM en Google Cloud, JIT no es la respuesta disponible ahí. También requiere Plan 2 explícitamente; Plan 1 y Foundational CSPM no lo incluyen.

## Lecciones donde aparece
- [[Dia 12 - Defender for Cloud Workload Protections]]
