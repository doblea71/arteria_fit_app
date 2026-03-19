## Why

Los ejercicios de respiración e isométricos requieren atención sostenida durante varios minutos. El sistema operativo puede apagar la pantalla o bloquear el dispositivo por inactividad, interrumpiendo la experiencia del usuario y potencialmente cortando los timers activos.

## What Changes

- Añadir paquete wakelock_plus al proyecto
- Activar wake lock al iniciar ejercicio de respiración
- Activar wake lock al iniciar ejercicio isométrico
- Desactivar wake lock al completar, detener o navegar fuera del ejercicio
- Liberar wake lock si la app pasa a segundo plano
- Reactivar wake lock si la app vuelve a primer plano con ejercicio activo
- Mantener wake lock solo durante ejercicios activos (no en otras pantallas)

## Capabilities

### New Capabilities

- **wake-lock-exercises**: Prevención de bloqueo de pantalla durante ejercicios activos

### Modified Capabilities

- Ninguno - es una nueva funcionalidad

## Impact

- **Archivos modificados**: `lib/features/breathing/breathing_screen.dart`, `lib/features/isometrics/isometrics_screen.dart`
- **Dependencias nuevas**: Paquete `wakelock_plus: ^1.5.1`
- **Breaking changes**: Ninguno
