# SPEC-003 — Notificación Háptica (Vibración) en Cambios de Fase

## Status: Proposed

## Context

Se prometió que en cada transición de paso/fase, tanto en el ejercicio de respiración 
(4-7-8) como en el ejercicio isométrico, el dispositivo vibraría para notificar al 
usuario sin que éste deba mirar la pantalla.

## Requirements

### REQ-003-1 — Vibración en cada transición de fase del ejercicio de respiración

Al cambiar de fase (Inhalar → Retener → Exhalar → Inhalar) en `breathing_screen.dart`, 
el sistema DEBE disparar una vibración táctil corta.

### REQ-003-2 — Vibración en cada transición de fase del ejercicio isométrico

Al cambiar de fase (Contracción → Descanso o fases equivalentes) en 
`isometrics_screen.dart`, el sistema DEBE disparar una vibración táctil corta.

### REQ-003-3 — Patrón de vibración diferenciado opcional

El sistema DEBERÍA diferenciar mediante patrones de vibración distintos el inicio 
de una fase de contracción vs. una fase de descanso (requisito de segunda prioridad).

### REQ-003-4 — Respeto a la configuración de vibración del dispositivo

Si el dispositivo tiene la vibración desactivada a nivel de sistema, el sistema 
NO DEBE producir vibración ni lanzar errores.

## Acceptance Criteria

- DADO QUE el ejercicio de respiración está en curso,
  CUANDO se produce una transición de fase,
  ENTONCES el dispositivo vibra una vez brevemente (≤ 200ms).

- DADO QUE el ejercicio isométrico está en curso,
  CUANDO se produce una transición de fase,
  ENTONCES el dispositivo vibra una vez brevemente (≤ 200ms).

- DADO QUE el dispositivo tiene vibración desactivada,
  CUANDO se produce cualquier transición de fase,
  ENTONCES la app no lanza excepciones y continúa normalmente.

## Technical Notes

- Usar el paquete `vibration` o `haptic_feedback` de Flutter.
- `HapticFeedback.mediumImpact()` como implementación mínima.
- Encapsular la llamada en un servicio `HapticService.phaseChange()` para 
  facilitar la personalización posterior.
- Archivos afectados: `breathing_screen.dart`, `isometrics_screen.dart`, 
  nuevo `services/haptic_service.dart`.