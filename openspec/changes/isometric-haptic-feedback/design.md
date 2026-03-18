## Context

El ejercicio isométrico tiene ciclos de contracción (ejercicio) y descanso. Actualmente no hay feedback háptico, y cuando se implementó para respiración (SPEC-003) se usó un único patrón para todas las fases.

## Goals / Non-Goals

**Goals:**
- Añadir métodos diferenciados en HapticService para contracción vs descanso
- Implementar vibración en todas las transiciones del ejercicio isométrico
- Usar patrones diferenciados cuando el dispositivo lo soporte

**Non-Goals:**
- No modificar la lógica de timing del ejercicio isométrico
- No añadir vibración al inicio/final del ejercicio completo (solo durante ciclos)

## Decisions

### DECISIÓN 1: Extender HapticService con métodos específicos

**Alternativa considerada**: Añadir parámetro al método existente
**Rationale**: Métodos separados (`contractionPhase()` y `restPhase()`) son más claros y mantenibles

### DECISIÓN 2: Usar paquete vibration para patrones personalizados

**Alternativa considerada**: Solo usar HapticFeedback nativo
**Rationale**: El paquete vibration permite patrones diferenciados, con fallback automático si no está disponible

### DECISIÓN 3: Implementar fallback automático

**Alternativa considerada**: Requerir el paquete vibration
**Rationale**: Si el paquete falla, usamos HapticFeedback.mediumImpact() como fallback

## Risks / Trade-offs

- **[Riesgo]**: El paquete vibration puede no funcionar en todos los dispositivos
  - **Mitigación**: Try-catch con fallback a HapticFeedback

## Migration Plan

1. Añadir métodos `contractionPhase()` y `restPhase()` a HapticService
2. Añadir paquete `vibration` a pubspec.yaml (con fallback)
3. Modificar isometrics_screen.dart para usar los nuevos métodos

## Open Questions

- Ninguno
