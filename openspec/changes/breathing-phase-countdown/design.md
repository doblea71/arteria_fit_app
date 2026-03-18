## Context

El ejercicio de respiración 4-7-8 tiene tres fases: Inhalar (4s), Mantener (7s), Exhalar (8s). La animación actual muestra feedback visual pero no indica numéricamente cuántos segundos faltan en cada fase.

## Goals / Non-Goals

**Goals:**
- Añadir contador regresivo que muestre segundos restantes en cada fase
- Renderizar el número detrás de la animación existente (no modificar animación)
- Usar opacidad baja para no distraer
- Resetear al cambiar de fase

**Non-Goals:**
- No modificar la animación existente
- No añadir animaciones adicionales al número

## Decisions

### DECISIÓN 1: Usar Stack widget para superposición

**Alternativa considerada**: Modificar la animación existente
**Rationale**: SPEC-010 indica explícitamente que la animación NO debe modificarse. Stack permite añadir el número como capa inferior.

### DECISIÓN 2: Usar Timer para decremento

**Alternativa considerada**: Usar AnimationController
**Rationale**: El decremento es simple (1 por segundo), Timer es más directo y compatible con el ciclo async existente.

### DECISIÓN 3: Usar color del tema con opacidad

**Alternativa considerada**: Color fijo
**Rationale**: Asegura consistencia visual en Light/Dark mode.

## Risks / Trade-offs

- **[Riesgo]**: El Timer puede desincronizarse con la animación
  - **Mitigación**: Resetear el contador y Timer al inicio de cada fase

## Migration Plan

1. Añadir `_phaseCountdown` e `_phaseCountdownTimer` al estado
2. Modificar `_runBreathingCycle()` para iniciar Timer en cada fase
3. Envolver la animación en un Stack con el número semi-transparente
4. Limpiar Timer en dispose()

## Open Questions

- Ninguno
