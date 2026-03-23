## Why

Evaluar y decidir sobre monetización pasiva P2B. La investigación de Infatica no fue viable (proceso lento), pero Honeygain SDK ofrece una alternativa directa con documentación pública, registro online y cumplimiento GDPR.

## What Changes

**Fase 1 (Investigación - Completada):**
- Investigar Infatica SDK → ❌ No viable (proceso lento)
- Investigar Honeygain SDK → ✅ Viable
- Crear documento de decisión → ✅ Completado

**Fase 2 (Implementación - Honeygain SDK):**
- Integrar Honeygain SDK
- Implementar PassiveMonetizationService
- Crear PassiveSupportToggle widget
- Actualizar Política de Privacidad
- Integrar en Settings

## Capabilities

### New Capabilities

- `infatica-research`: Documento de investigación de SDKs de monetización pasiva
- `monetization-decision`: Documento formal de decisión técnica (Honeygain SDK aprobado)
- `passive-monetization-service`: Servicio Flutter para gestionar monetización Honeygain
- `passive-support-toggle`: Widget toggle para activar/desactivar monetización

### Modified Capabilities

- `privacy-policy`: Actualizar con sección de monetización pasiva Honeygain

## Impact

**Fase 1 (Completada):**
- Nuevo: `docs/DECISION_MONETIZACION_PASIVA.md`

**Fase 2:**
- Nuevo: `lib/core/services/passive_monetization_service.dart`
- Nuevo: `lib/widgets/passive_support_toggle.dart`
- Modificado: `docs/privacy-policy.html`
- Modificado: `lib/features/settings/settings_screen.dart`
- Dependencias: Honeygain SDK (por definir tras registro)
