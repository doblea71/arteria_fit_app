## Why

Se prometió que en cada transición de fase, tanto en respiración como en isométricos, el dispositivo vibraría para notificar al usuario sin que tenga que mirar la pantalla. Esta funcionalidad aún no está implementada.

## What Changes

- Crear servicio HapticService para encapsular la lógica de vibración
- Añadir vibración en transiciones de fase del ejercicio de respiración (Inhalar → Retener → Exhalar)
- Añadir vibración en transiciones de fase del ejercicio isométrico (Contracción → Descanso)
- Manejar caso donde la vibración está desactivada a nivel de sistema

## Capabilities

### New Capabilities

- **haptic-phase-notifications**: Notificaciones hápticas (vibración) en transiciones de fase de ejercicios

### Modified Capabilities

- Ninguno - es una nueva funcionalidad

## Impact

- **Archivos nuevos**: `lib/core/services/haptic_service.dart`
- **Archivos modificados**: `lib/features/breathing/breathing_screen.dart`, `lib/features/isometrics/isometrics_screen.dart`
- **Dependencias nuevas**: Paquete `vibration` o usar `HapticFeedback` de Flutter
- **Breaking changes**: Ninguno
