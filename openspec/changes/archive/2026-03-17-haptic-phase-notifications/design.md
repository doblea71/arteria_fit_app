## Context

El ejercicio de respiración 4-7-8 tiene tres fases (Inhalar, Retener, Exhalar) y los ejercicios isométricos tienen fases de Contracción y Descanso. Actualmente no hay retroalimentación háptica cuando cambia una fase, lo que obliga al usuario a mirar la pantalla constantemente.

## Goals / Non-Goals

**Goals:**
- Implementar vibración en cada transición de fase de respiración
- Implementar vibración en cada transición de fase de isométricos
- Manejar gracefully el caso donde la vibración está desactivada

**Non-Goals:**
- No implementar patrones de vibración diferenciados (REQ-003-3 es de segunda prioridad)
- No añadir configuración de vibración en Settings

## Decisions

### DECISIÓN 1: Usar HapticFeedback de Flutter en lugar del paquete vibration

**Alternativa considerada**: Usar paquete `vibration` de pub.dev
**Rationale**: `HapticFeedback` está disponible en Flutter nativamente, no requiere dependencias adicionales, y `mediumImpact()` cumple con el requisito de ≤200ms

### DECISIÓN 2: Crear HapticService como clase singleton

**Alternativa considerada**: Llamar HapticFeedback directamente en cada screen
**Rationale**: Encapsular en un servicio permite personalización futura y facilita testing

## Risks / Trade-offs

- **[Riesgo]**: En iOS simulators, HapticFeedback no funciona
  - **Mitigación**: Verificar en dispositivo real, no lanza excepción

## Migration Plan

1. Crear `lib/core/services/haptic_service.dart` con método `phaseChange()`
2. Importar en breathing_screen.dart y añadir llamada en cada transición de fase
3. Importar en isometrics_screen.dart y añadir llamada en cada transición de fase

## Open Questions

- Ninguno - la implementación es directa
