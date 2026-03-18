## Context

La implementación actual en breathing_screen.dart llama `HapticService().phaseChange()` ANTES de `setState()` que cambia la fase. Esto causa:
1. Vibración en Hold y Exhale pero NO en Inhale
2. Posible vibración duplicada en transición Exhale → Inhale (llamada al final del ciclo + al inicio del siguiente)

## Goals / Non-Goals

**Goals:**
- Añadir vibración al inicio de la fase Inhalar
- Mover la vibración DESPUÉS del setState para que sea consistente
- Evitar vibración doble en transición Exhale → Inhale
- No disparar vibración de Inhalar en el cierre gracioso (SPEC-001)

**Non-Goals:**
- No modificar HapticService - ya funciona correctamente
- No añadir nuevas funcionalidades

## Decisions

### DECISIÓN 1: Vibración DESPUÉS de setState

**Alternativa considerada**: Mantener vibración antes de setState
**Rationale**: Es más semánticamente correcto vibrar cuando el usuario ve el cambio de fase, no antes

### DECISIÓN 2: No vibrar en _startSession() para Inhalar inicial

**Alternativa considerada**: Vibrar al iniciar sesión
**Rationale**: SPEC-008 indica que la vibración debe ser al COMENZAR la fase Inhalar, no al iniciar la sesión. El inicio de sesión ya tiene feedback visual con el botón.

## Risks / Trade-offs

- **[Riesgo]**: Mover la vibración puede afectar el timing percibido
  - **Mitigación**: El cambio es mínimo (reordenar líneas), el timing real no cambia

## Migration Plan

1. En `_runBreathingCycle()`:
   - Añadir `HapticService().phaseChange()` DESPUÉS de `setState(() => _currentPhase = BreathingPhase.inhale)`
   - Mover las vibraciones existentes DESPUÉS de sus respectivos setState
   - NO añadir vibración en `_runFinalExhale()` para la fase Inhalar

## Open Questions

- Ninguno
