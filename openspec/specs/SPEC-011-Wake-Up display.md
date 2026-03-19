# SPEC-011 — Prevención de Bloqueo de Pantalla Durante Ejercicios Activos

## Status: Implemented

## Context

Los ejercicios de respiración e isométricos requieren atención sostenida
durante varios minutos. El sistema operativo del dispositivo puede apagar
la pantalla o bloquear el dispositivo por inactividad táctil durante la
ejecución del ejercicio, interrumpiendo la experiencia del usuario y
potencialmente cortando los timers activos del ejercicio.
Se requiere mantener la pantalla encendida y desbloqueada únicamente
mientras un ejercicio está en curso, liberando el wake lock en cualquier
otro estado de la app.

## Requirements

### REQ-011-1 — Activación del wake lock al iniciar un ejercicio

El sistema DEBE activar el wake lock del dispositivo (mantener pantalla
encendida) en el momento exacto en que el usuario inicia un ejercicio
de respiración o un ejercicio isométrico.

### REQ-011-2 — Desactivación del wake lock al finalizar el ejercicio

El sistema DEBE liberar el wake lock inmediatamente cuando:
  a) El ejercicio se completa normalmente.
  b) El usuario detiene el ejercicio manualmente.
  c) El usuario navega fuera de la pantalla del ejercicio.
  d) La app pasa a segundo plano (AppLifecycleState.paused).

### REQ-011-3 — No mantener wake lock fuera del contexto de ejercicio

El sistema NO DEBE mantener el wake lock activo en ninguna pantalla
que no sea una sesión de ejercicio activa. El dashboard, la pantalla
de nutrición, ajustes y actividad NO deben afectar el comportamiento
de la pantalla del dispositivo.

### REQ-011-4 — Liberación garantizada ante cierre inesperado

El wake lock DEBE liberarse en el método `dispose()` del widget
del ejercicio para garantizar que no quede activo si el widget
es destruido por cualquier causa no controlada.

### REQ-011-5 — Compatibilidad con el ciclo de vida de la app

Si la app pasa a segundo plano durante un ejercicio activo, el wake
lock DEBE liberarse. Al volver a primer plano con el ejercicio aún
en curso, el wake lock DEBE reactivarse.

## Acceptance Criteria

- DADO QUE el usuario pulsa el botón de inicio del ejercicio de respiración,
  CUANDO el ejercicio comienza,
  ENTONCES la pantalla permanece encendida indefinidamente sin
  bloquearse por inactividad táctil.

- DADO QUE el ejercicio está en curso y el usuario navega al dashboard,
  CUANDO se destruye la pantalla del ejercicio,
  ENTONCES el wake lock es liberado y el comportamiento de la pantalla
  vuelve a ser el del sistema operativo.

- DADO QUE el ejercicio está en curso y el usuario presiona Home,
  CUANDO la app pasa a AppLifecycleState.paused,
  ENTONCES el wake lock es liberado.

- DADO QUE el usuario regresa a la app con el ejercicio aún en curso,
  CUANDO la app vuelve a AppLifecycleState.resumed,
  ENTONCES el wake lock se reactiva.

- DADO QUE el dispositivo tiene restricciones de batería extremas,
  CUANDO el sistema rechaza el wake lock,
  ENTONCES la app NO lanza excepciones y el ejercicio continúa
  normalmente sin wake lock.

## Technical Notes

### Paquete recomendado

Usar el paquete `wakelock_plus` (sucesor oficial de `wakelock`,
compatible con Flutter 3.x y null safety):

```yaml
dependencies:
  wakelock_plus: ^1.2.4
```

### Implementación recomendada

```dart
import 'package:wakelock_plus/wakelock_plus.dart';

// Al iniciar el ejercicio
WakelockPlus.enable();

// Al finalizar o salir del ejercicio
WakelockPlus.disable();
```