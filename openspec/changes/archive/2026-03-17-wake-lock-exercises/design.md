## Context

Los ejercicios de respiración (4-7-8) e isométricos duran varios minutos. Sin wake lock, el dispositivo puede apagar la pantalla por inactividad, interrumpiendo el ejercicio.

## Goals / Non-Goals

**Goals:**
- Mantener pantalla encendida durante ejercicios activos
- Liberar wake lock en todos los casos de salida
- Manejar ciclo de vida de la app (background/foreground)
- No afectar comportamiento en otras pantallas

**Non-Goals:**
- No implementar configuración de wake lock por el usuario
- No mantener wake lock en dashboard, nutrición, etc.

## Decisions

### DECISIÓN 1: Usar wakelock_plus en lugar de wakelock

**Alternativa considerada**: Usar `WakeLock` nativo o `screen_brightness`
**Rationale**: `wakelock_plus` es el sucesor oficial de `wakelock`, compatible con Flutter 3.x y null safety

### DECISIÓN 2: Integrar wake lock directamente en cada screen

**Alternativa considerada**: Crear un servicio centralizado
**Rationale**: La implementación es simple (enable/disable) y los ejercicios son independientes

### DECISIÓN 3: Usar WidgetsBindingObserver para ciclo de vida

**Alternativa considerada**: Usar Provider para estado global
**Rationale**: `WidgetsBindingObserver` es el método nativo de Flutter para detectar cambios de lifecycle

## Risks / Trade-offs

- **[Riesgo]**: Algunos dispositivos pueden rechazar el wake lock
  - **Mitigación**: Wrappear en try-catch, no lanzar excepciones

## Migration Plan

1. Añadir `wakelock_plus: ^1.2.4` a pubspec.yaml
2. Implementar en breathing_screen.dart con lifecycle observer
3. Implementar en isometrics_screen.dart con lifecycle observer
4. Verificar que dispose() siempre libera el wake lock

## Open Questions

- Ninguno
