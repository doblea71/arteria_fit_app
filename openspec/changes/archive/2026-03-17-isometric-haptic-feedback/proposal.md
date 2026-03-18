# Why

El ejercicio isométrico en isometrics_screen.dart actualmente no tiene implementada ninguna señal háptica. El usuario necesita ser notificado en cada cambio de fase (contracción → descanso → contracción) sin tener que mirar la pantalla durante el ejercicio.

## What Changes

- Extender HapticService con métodos diferenciados para contracción y descanso
- Implementar vibración al inicio de cada fase de contracción isométrica
- Implementar vibración al inicio de cada fase de descanso
- Usar patrón diferenciado (doble pulso para contracción, pulso único para descanso)
- Mantener fallback a pulso único si patrones no están disponibles

## Capabilities

### New Capabilities

- **isometric-haptic-feedback**: Vibración diferenciada en todas las fases del ejercicio isométrico

### Modified Capabilities

- **haptic-phase-notifications**: Extender HapticService con métodos contractionPhase() y restPhase()

## Impact

- **Archivos modificados**: `lib/core/services/haptic_service.dart`, `lib/features/isometrics/isometrics_screen.dart`
- **Dependencias nuevas**: Paquete `vibration` para patrones personalizados (opcional, con fallback)
- **Breaking changes**: Ninguno
