# SPEC-001 — Finalización Grácil del Ejercicio 4-7-8 (breathing_screen.dart)

## Status: Proposed

## Context

El método de respiración 4-7-8 consta de tres fases: Inhalar (4s), Retener (7s) y
Exhalar (8s). Cuando el temporizador global del ejercicio llega a 0 durante la
transición hacia la fase de Exhalar, el ejercicio se cierra abruptamente sin completar
la última fase, dejando al usuario sin señal de cuándo terminar de exhalar.

## Requirements

### REQ-001-1 — Completar la fase de Exhalación al expirar el temporizador

Cuando el temporizador global llegue a 0 y el ciclo 4-7-8 esté en cualquiera de las
fases Inhalar o Retener, el sistema DEBE permitir que el ciclo avance hasta iniciar
la fase Exhalar antes de cerrar el ejercicio.

### REQ-001-2 — Mostrar indicador "Exhalar" durante los últimos segundos

Una vez iniciada la fase Exhalar forzada al final del temporizador, el sistema DEBE
mostrar el indicador visual "Exhalar" durante exactamente 8 segundos, independientemente
del tiempo restante del temporizador global.

### REQ-001-3 — Cierre del ejercicio tras la exhalación final

Transcurridos los 8 segundos de la fase Exhalar final, el sistema DEBE ejecutar la
lógica de cierre actual: reactivar los botones de control y detener la animación.

### REQ-001-4 — No iniciar un nuevo ciclo tras la exhalación final

El sistema NO DEBE iniciar un nuevo ciclo 4-7-8 después de la exhalación forzada
al expirar el temporizador global.

## Acceptance Criteria

- DADO QUE el temporizador global llega a 0 durante la fase Inhalar (4s),
  CUANDO se detecta la expiración del temporizador,
  ENTONCES el sistema avanza a la fase Retener y luego a Exhalar, mostrando
  "Exhalar" por 8 segundos antes de cerrar.

- DADO QUE el temporizador global llega a 0 durante la fase Retener (7s),
  CUANDO se detecta la expiración del temporizador,
  ENTONCES el sistema avanza directamente a Exhalar, mostrando "Exhalar"
  por 8 segundos antes de cerrar.

- DADO QUE el temporizador global llega a 0 durante la fase Exhalar (8s),
  CUANDO se detecta la expiración del temporizador,
  ENTONCES el sistema completa el tiempo restante de Exhalar y luego cierra.

## Technical Notes

- Introducir un flag booleano `_isFinalCycle` en el estado del widget.
- Al detectar expiración del timer global, activar `_isFinalCycle = true` y dejar correr el sub-timer de la fase actual hasta completar Exhalar.
- Archivo afectado: `lib/screens/breathing_screen.dart`
