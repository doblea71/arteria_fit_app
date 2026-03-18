# SPEC-008 — Vibración Completa en Todas las Fases del Ciclo 4-7-8

## Status: Proposed

## Context

La implementación actual de vibraciones en `breathing_screen.dart` dispara
la señal háptica al inicio de las fases "Mantener" y "Exhalar", pero omite
la vibración al inicio de la fase "Inhalar". Esto provoca que la transición
Exhalar → Inhalar (cierre y reapertura del ciclo) no tenga aviso háptico,
dejando al usuario sin señal de cuándo debe comenzar a inhalar nuevamente.

## Requirements

### REQ-008-1 — Vibración al inicio de la fase Inhalar

El sistema DEBE disparar una vibración háptica corta inmediatamente al
comenzar la fase "Inhalar", tanto en la primera iteración del ciclo como
en cada repetición posterior.

### REQ-008-2 — Vibración al inicio de la fase Mantener

El sistema DEBE mantener la vibración existente al inicio de la fase
"Mantener". Este requisito documenta el comportamiento actual correcto
para no regresionarlo.

### REQ-008-3 — Vibración al inicio de la fase Exhalar

El sistema DEBE mantener la vibración existente al inicio de la fase
"Exhalar". Este requisito documenta el comportamiento actual correcto
para no regresionarlo.

### REQ-008-4 — Cobertura de la transición Exhalar → Inhalar

El sistema DEBE garantizar que la transición del final de "Exhalar" al
inicio del siguiente "Inhalar" dispare exactamente UNA vibración,
correspondiente al inicio de la nueva fase "Inhalar", sin duplicados.

### REQ-008-5 — Vibración en la fase Inhalar forzada por fin de temporizador

Cuando se active el mecanismo de cierre grácil definido en SPEC-001,
si el sistema fuerza el avance hasta la fase "Exhalar" final, NO DEBE
dispararse vibración de inicio de "Inhalar" para ese ciclo truncado,
ya que dicha fase no se ejecuta completa.

## Acceptance Criteria

- DADO QUE el ejercicio de respiración acaba de iniciarse,
  CUANDO comienza la primera fase "Inhalar",
  ENTONCES el dispositivo vibra una vez brevemente (≤ 200ms).

- DADO QUE el ciclo está en la fase "Exhalar",
  CUANDO se completan los 8 segundos y se inicia un nuevo ciclo,
  ENTONCES el dispositivo vibra exactamente una vez al comenzar "Inhalar",
  Y no vibra una segunda vez por ningún otro evento.

- DADO QUE se ejecutan 3 ciclos completos seguidos,
  CUANDO se observan los eventos hápticos,
  ENTONCES se producen exactamente 9 vibraciones
  (3 por ciclo × 3 ciclos: Inhalar, Mantener, Exhalar).

- DADO QUE el temporizador global expira durante cualquier fase,
  CUANDO se activa el cierre grácil de SPEC-001,
  ENTONCES no se disparan vibraciones adicionales fuera del ciclo normal.

## Technical Notes

- La vibración de cada fase DEBE dispararse en el mismo punto del código
  donde se actualiza el estado de la fase actual (setState o notifyListeners).
- Centralizar la lógica en `HapticService.phaseChange()` definido en
  SPEC-003 para mantener consistencia.
- Revisar si existe un listener, Timer o StreamController que maneje
  las transiciones; la vibración debe ir inmediatamente después del
  cambio de fase, no antes.
- Verificar que no exista una vibración duplicada producto de un
  callback de finalización del sub-timer anterior y el inicio del
  nuevo estado simultáneamente.
- Archivos afectados: `lib/screens/breathing_screen.dart`,
  `lib/services/haptic_service.dart`.

## Dependencias

- SPEC-003 debe estar implementado (HapticService disponible).
- Considerar interacción con SPEC-001 (cierre grácil).
