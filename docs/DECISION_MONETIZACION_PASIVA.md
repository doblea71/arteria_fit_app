# Decisión de Monetización Pasiva

**Fecha:** 23 de marzo de 2026  
**Proyecto:** Arteria Fit  
**Estado:** ⏸️ **EN ESPERA** - Revisar cuando Honeygain mejore onboarding

---

## Resumen Ejecutivo

Se ha evaluado la viabilidad de implementar monetización pasiva P2B en Arteria Fit mediante SDKs de terceros.

**Decisión:** ✅ **IMPLEMENTAR - Honeygain SDK**

**Justificación:** Honeygain SDK ofrece un proceso de integración directo, documentación disponible, cumplimiento GDPR explícito y tiempo de implementación de 1-2 días.

---

## Investigación Realizada

### Opción 1: Infatica SDK

| Aspecto | Resultado |
|---------|-----------|
| ¿SDK disponible? | ⚠️ No público |
| ¿Documentación? | Requiere partnership |
| ¿Proceso de registro? | Contactar equipo, lento |
| ¿GDPR compliant? | Mencionan certificaciones ISO |
| ¿Tiempo de implementación? | Semanas (por等待 equipo) |

**Conclusión:** ❌ **No viable** - El proceso requiere partnership formal y tiempos de respuesta del equipo.

### Opción 2: Honeygain SDK ✅

| Aspecto | Resultado |
|---------|-----------|
| ¿SDK disponible? | ✅ Sí |
| ¿Documentación? | ✅ https://developers.honeygain.com/docs/ |
| ¿Proceso de registro? | ✅ Registro online directo |
| ¿GDPR compliant? | ✅ GDPR y CCPA |
| ¿Tiempo de implementación? | ✅ 1-2 días |
| ¿Seguridad? | ✅ Pentested por Blaze Infosec |
| ¿Plataformas? | ✅ Android, iOS, Desktop |

**Conclusión:** ✅ **Viable** - Proceso directo, documentación disponible.

### Alternativas Consideradas

| Proveedor | Estado | Notas |
|-----------|--------|-------|
| PacketStream | No investigado | Tiempo limitado |
| TraffMonetizer | No investigado | Tiempo limitado |

---

## Criterios de Evaluación

| Criterio | Umbral mínimo | Honeygain |
|----------|---------------|-----------|
| SDK móvil disponible | Sí | ✅ |
| Documentación accesible | Sí | ✅ |
| Proceso de registro claro | Sí | ✅ |
| Términos GDPR | Compatible | ✅ |
| Modelo de ingresos | Viable | ✅ ($500/DAU max) |
| Tiempo de implementación | < 7 días | ✅ 1-2 días |

---

## Decisión Final

### ✅ PROCEDER CON HONEYGAIN SDK

**Razones:**
1. Registro directo online (no esperar respuestas de equipo)
2. Documentación pública completa
3. Cumplimiento GDPR explícito
4. Tiempo de integración rápido (1-2 días)
5. Soporte para Android e iOS
6. Seguridad auditada (Blaze Infosec)
7. Modelo de ingresos transparent ($500/DAU max)

### Pasos Siguientes

1. [ ] Registrar cuenta en https://sdk.honeygain.com/dashboard/register
2. [ ] Obtener credenciales/API keys
3. [ ] Revisar documentación técnica
4. [ ] Implementar PassiveMonetizationService
5. [ ] Crear PassiveSupportToggle widget
6. [ ] Integrar en Settings
7. [ ] Actualizar Política de Privacidad
8. [ ] Testing y publicación

---

## Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|---------|--------------|---------|------------|
| App Store rejection | Media | Alto | Honeygain es explícitamente compatible |
| Impacto en batería | Baja | Medio | Restricciones Wi-Fi + batería > 50% |
| Usuarios negativos | Baja | Medio | Consentimiento claro, opt-in |

---

## Recursos

- **Registro:** https://sdk.honeygain.com/dashboard/register
- **Documentación:** https://developers.honeygain.com/docs/
- **Trust Center:** https://sdk.honeygain.com/trust-center/
- **FAQ:** https://sdk.honeygain.com/faq/
