# SPEC-009 — Implementación de Vibración en Ciclos del Ejercicio Isométrico

## Status: Implemented

## Context

El ejercicio isométrico en `isometrics_screen.dart` no tiene implementada
ninguna señal háptica. El ejercicio consiste en ciclos repetidos que
incluyen fases de contracción muscular y fases de descanso. El usuario
necesita ser avisado en cada cambio de fase para no tener que mirar
la pantalla durante el ejercicio.
Se debe cubrir la totalidad de las transiciones, incluyendo los períodos
de descanso entre series y la transición del último paso de vuelta
al primero al reiniciarse el ciclo.

## Requirements

### REQ-009-1 — Vibración al inicio de cada fase de contracción

El sistema DEBE disparar una vibración háptica corta al inicio de
cada fase activa de contracción isométrica.

### REQ-009-2 — Vibración al inicio de cada fase de descanso

El sistema DEBE disparar una vibración háptica corta al inicio de
cada período de descanso entre contracciones o entre series.

### REQ-009-3 — Vibración en la transición del último paso al primero

Al completarse el último paso de un ciclo isométrico completo y
comenzar el siguiente ciclo desde el primer paso, el sistema DEBE
disparar la vibración correspondiente al inicio de dicho primer paso,
sin omisiones ni duplicados.

### REQ-009-4 — Patrón de vibración diferenciado por tipo de fase

El sistema DEBERÍA usar patrones hápticos distintos para diferenciar
al usuario entre el inicio de una fase de contracción (esfuerzo)
y el inicio de una fase de descanso (reposo):

- Contracción: 2 pulsos cortos (≤ 100ms cada uno, separados por 50ms).
- Descanso: 1 pulso suave (≤ 150ms).
  
  Si el dispositivo no soporta patrones personalizados, se usará
  un único pulso corto (≤ 200ms) para ambos tipos.

### REQ-009-5 — Respeto a la configuración de vibración del dispositivo

Si el dispositivo tiene vibración desactivada a nivel de sistema,
el sistema NO DEBE lanzar excepciones ni interrumpir el ejercicio.

## Acceptance Criteria

- DADO QUE el ejercicio isométrico está en curso con N fases por ciclo,
  CUANDO se ejecuta un ciclo completo,
  ENTONCES se producen exactamente N vibraciones, una al inicio de
  cada fase.

- DADO QUE el ciclo isométrico llega a su última fase,
  CUANDO esa fase termina y comienza la primera fase del siguiente ciclo,
  ENTONCES el dispositivo vibra exactamente una vez al iniciar la
  primera fase del nuevo ciclo.

- DADO QUE una fase es de descanso,
  CUANDO comienza esa fase,
  ENTONCES el patrón háptico es distinguible del de una fase de
  contracción (si el dispositivo lo soporta).

- DADO QUE el dispositivo tiene vibración desactivada,
  CUANDO ocurre cualquier transición de fase,
  ENTONCES el ejercicio continúa normalmente sin errores.

## Technical Notes

- Usar `HapticService` de SPEC-003. Extender el servicio con dos
  métodos diferenciados:
  - `HapticService.contractionPhase()` → doble pulso.
  - `HapticService.restPhase()` → pulso único suave.
- Para patrones personalizados usar el paquete `vibration`
  (`Vibration.vibrate(pattern: [0, 100, 50, 100])`).
- Fallback a `HapticFeedback.mediumImpact()` si `vibration`
  no está disponible.
- Mapear cada tipo de fase del modelo de datos isométrico
  al método háptico correspondiente antes de dispararlo.
- Archivos afectados: `lib/screens/isometrics_screen.dart`,
  `lib/services/haptic_service.dart`.

## Dependencias

- SPEC-003 debe estar implementado (HapticService disponible).
