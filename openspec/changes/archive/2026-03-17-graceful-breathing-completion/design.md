## Context

El ejercicio de respiración 4-7-8 tiene tres fases: Inhalar (4s), Retener (7s), Exhalar (8s). Actualmente, cuando el temporizador global (`_secondsLeft`) llega a 0, el método `_stopSession()` se ejecuta inmediatamente, cerrando el ejercicio abruptamente sin importar en qué fase se encuentre el ciclo actual.

## Goals / Non-Goals

**Goals:**
- Completar la fase de Exhalar (8s) cuando el temporizador global expira durante Inhalar o Retener
- Mostrar indicador "Exhalar" durante 8 segundos antes de cerrar
- No iniciar nuevos ciclos después de la exhalación final

**Non-Goals:**
- No modificar la duración de las fases del ciclo normal
- No añadir nuevas funcionalidades al ejercicio

## Decisions

### DECISIÓN 1: Usar flag `_isFinalCycle` para detectar expiración

**Alternativa considerada**: Modificar directamente la lógica en `_stopSession()`
**Rationale**: Un flag booleano permite diferenciar entre cierre normal (usuario presiona stop) y cierre por expiración del temporizador, facilitando la lógica de "completar exhalación"

### DECISIÓN 2: Ejecutar fase Exhalar como sub-timer separado

**Alternativa considerada**: Ejecutar toda la fase Exhalar con await
**Rationale**: Necesitamos un timer separado de 8 segundos que corra independientemente del temporizador global, para mostrar "Exhalar" exactamente 8 segundos

### DECISIÓN 3: No registrar ejercicio si no se completa la exhalación final

**Alternativa considerada**: Registrar ejercicio cuando expire el timer global
**Rationale**: Para mantener la integridad del registro, solo registramos si se completó al menos la fase de exhalación final

## Risks / Trade-offs

- **[Riesgo]**: El usuario puede sentirse confundido si el ejercicio no termina inmediatamente al llegar el timer a 0
  - **Mitigación**: La fase Exhalar es corta (8s) y proporciona feedback visual claro

## Migration Plan

1. Añadir flag `_isFinalCycle = false` al estado
2. Modificar `_timer` callback para activar `_isFinalCycle` cuando `_secondsLeft == 0`
3. En `_runBreathingCycle()`, verificar `_isFinalCycle` antes de iniciar nuevo ciclo
4. Añadir `_runFinalExhale()` que muestra "Exhalar" por 8 segundos y luego llama a `_stopSession()`
5. Modificar `_stopSession()` para manejar el caso de expiración

## Open Questions

- Ninguno - la implementación es directa
