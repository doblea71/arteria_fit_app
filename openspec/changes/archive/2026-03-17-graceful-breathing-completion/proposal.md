## Why

El método de respiración 4-7-8 tiene tres fases: Inhalar (4s), Retener (7s) y Exhalar (8s). Cuando el temporizador global llega a 0 durante las fases Inhalar o Retener, el ejercicio se cierra abruptamente sin completar la fase de Exhalar, dejando al usuario sin señal de cuándo terminar de exhalar correctamente.

## What Changes

- Añadir flag `_isFinalCycle` para detectar cuando el temporizador global expira
- Modificar la lógica de cierre para avanzar a la fase Exhalar antes de terminar
- Mostrar indicador "Exhalar" durante 8 segundos al finalizar
- Impedir que se inicie un nuevo ciclo después de la exhalación final

## Capabilities

### New Capabilities

- **graceful-breathing-completion**: Completar la fase de exhalación al expirar el temporizador global del ejercicio 4-7-8

### Modified Capabilities

- Ninguno - es una nueva funcionalidad

## Impact

- **Archivos modificados**: `lib/features/breathing/breathing_screen.dart`
- **Dependencias nuevas**: Ninguna
- **Breaking changes**: Ninguno
