## Why

La implementación actual de vibraciones en breathing_screen.dart dispara haptic feedback al inicio de las fases "Mantener" y "Exhalar", pero omite la vibración al inicio de la fase "Inhalar". Esto deja al usuario sin señal háptica al comenzar cada ciclo, especialmente en la transición Exhalar → Inhalar.

## What Changes

- Añadir vibración al inicio de la fase "Inhalar" en cada ciclo
- Mantener las vibraciones existentes en Mantener y Exhalar
- Evitar vibración doble al final de Exhalar (solo una al iniciar nuevo Inhalar)
- No disparar vibración de Inhalar en el cierre gracioso (SPEC-001)

## Capabilities

### New Capabilities

- Ninguno - es una corrección de la funcionalidad existente de SPEC-003

### Modified Capabilities

- **haptic-phase-notifications**: Añadir vibración en fase Inhalar, evitar duplicados en transición Exhalar→Inhalar

## Impact

- **Archivos modificados**: `lib/features/breathing/breathing_screen.dart`
- **Dependencias**: HapticService de SPEC-003 ya implementado
- **Breaking changes**: Ninguno
