## Why

Durante el ejercicio de respiración 4-7-8 el usuario ve una animación por cada fase pero no tiene retroalimentación numérica de cuántos segundos restan en la fase actual. Se requiere superponer un número grande y semi-transparente detrás de la animación existente que cuente de forma regresiva.

## What Changes

- Añadir contador regresivo semi-transparente en cada fase (Inhalar: 4, Mantener: 7, Exhalar: 8)
- Mostrar el número detrás de la animación (z-order inferior)
- Usar opacidad entre 0.15-0.25 para no distraer
- Resetear el contador al cambiar de fase
- Soportar modo Light/Dark
- Compatible con el cierre grácil de SPEC-001

## Capabilities

### New Capabilities

- **breathing-phase-countdown**: Contador regresivo por fase en el ejercicio de respiración 4-7-8

### Modified Capabilities

- Ninguno - es una nueva funcionalidad

## Impact

- **Archivos modificados**: `lib/features/breathing/breathing_screen.dart`
- **Dependencias nuevas**: Ninguna
- **Breaking changes**: Ninguno
