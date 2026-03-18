# SPEC-010 — Overlay de Cuenta Regresiva por Fase en breathing_screen.dart

## Status: Proposed

## Context

Durante el ejercicio de respiración 4-7-8 el usuario ve una animación
por cada fase pero no tiene retroalimentación numérica de cuántos
segundos restan en la fase actual. Se requiere superponer un número
grande y semi-transparente detrás de la animación existente que cuente
de forma regresiva desde el número máximo de la fase (4, 7 u 8) hasta 1,
decreciendo cada segundo. La animación actual NO debe modificarse.

## Requirements

### REQ-010-1 — Número regresivo en la fase Inhalar

Durante la fase "Inhalar", el sistema DEBE mostrar un número regresivo
que comience en 4 y decremente en 1 cada segundo (4 → 3 → 2 → 1),
desapareciendo al completarse la fase.

### REQ-010-2 — Número regresivo en la fase Mantener

Durante la fase "Mantener", el sistema DEBE mostrar un número regresivo
que comience en 7 y decremente en 1 cada segundo (7 → 6 → ... → 1),
desapareciendo al completarse la fase.

### REQ-010-3 — Número regresivo en la fase Exhalar

Durante la fase "Exhalar", el sistema DEBE mostrar un número regresivo
que comience en 8 y decremente en 1 cada segundo (8 → 7 → ... → 1),
desapareciendo al completarse la fase.

### REQ-010-4 — Posicionamiento detrás de la animación existente

El número DEBE renderizarse en una capa inferior (z-order) a la
animación actual, de modo que la animación quede siempre visible
en primer plano. El número NO DEBE tapar ni interferir visualmente
con la animación.

### REQ-010-5 — Estilo semi-transparente del número

El número DEBE renderizarse con una opacidad entre 0.15 y 0.25
(a calibrar visualmente) para no distraer al usuario de la animación
principal. El tamaño de fuente DEBE ser suficientemente grande para
ser legible detrás de la animación (referencia inicial: 180sp – 220sp).

### REQ-010-6 — Centrado en el área de la animación

El número DEBE estar centrado horizontal y verticalmente en el mismo
espacio que ocupa la animación principal.

### REQ-010-7 — Reset del contador al cambiar de fase

Al producirse una transición de fase, el número DEBE cambiar
instantáneamente al valor inicial de la nueva fase (sin animación
de transición del propio número). El decremento de cada fase comienza
desde el número máximo de esa fase, no desde el valor donde quedó
la fase anterior.

### REQ-010-8 — Consistencia con el tema Light/Dark

El color del número DEBE derivarse del tema activo de la app.

- Modo Light: número en color oscuro semi-transparente.
- Modo Dark: número en color claro semi-transparente.
  El color base DEBE tomarse de `Theme.of(context).colorScheme.onBackground`
  con la opacidad aplicada encima.

### REQ-010-9 — Compatibilidad con el cierre grácil de SPEC-001

Durante la fase "Exhalar" forzada al final del temporizador global
(SPEC-001), el contador regresivo DEBE seguir funcionando normalmente
desde 8 hasta 1, proporcionando al usuario la señal de cuándo
termina la exhalación final.

## Acceptance Criteria

- DADO QUE comienza la fase "Inhalar",
  CUANDO el widget se renderiza,
  ENTONCES se ve el número 4 detrás de la animación con opacidad
  entre 0.15 y 0.25, centrado en el área de la animación.

- DADO QUE han transcurrido 2 segundos en la fase "Inhalar",
  CUANDO el widget se renderiza,
  ENTONCES se ve el número 2 (no el 4 ni el 3).

- DADO QUE la fase "Inhalar" termina y comienza "Mantener",
  CUANDO ocurre la transición,
  ENTONCES el número cambia instantáneamente a 7 y comienza
  a decrementar desde ahí.

- DADO QUE la app está en modo Dark,
  CUANDO se muestra el contador,
  ENTONCES el número usa un color claro semi-transparente,
  no un color oscuro.

- DADO QUE la animación principal está activa,
  CUANDO ambos elementos se renderizan simultáneamente,
  ENTONCES la animación es visible en primer plano y el número
  no la obstruye.

## Technical Notes

### Implementación con Stack

Usar un widget `Stack` para superponer capas en el siguiente orden
(de abajo hacia arriba):

```dart
Stack(
  alignment: Alignment.center,
  children: [
    // Capa 1 (fondo): número regresivo
    Opacity(
      opacity: 0.20,
      child: Text(
        '$_phaseCountdown',
        style: TextStyle(
          fontSize: 200,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    ),
    // Capa 2 (frente): animación existente — SIN MODIFICAR
    ExistingBreathingAnimation(),
  ],
)
```

### Estado requerido

Agregar a la clase State:

- `int _phaseCountdown` → valor actual del contador.
- `Timer? _countdownTimer` → timer de 1 segundo para decrementar.

Al cambiar de fase:

1. Cancelar `_countdownTimer` anterior.
2. Asignar `_phaseCountdown` al valor máximo de la nueva fase.
3. Iniciar nuevo `_countdownTimer` con `Duration(seconds: 1)`
   que decremente `_phaseCountdown` en cada tick.

### Cancelación de timers

En `dispose()` del widget, cancelar `_countdownTimer` para
evitar memory leaks.

- Archivo afectado: `lib/screens/breathing_screen.dart`.

## Dependencias

- No depende de otros SPECs pendientes.
- Considerar interacción con SPEC-001 (fase Exhalar forzada):
  el `_countdownTimer` debe inicializarse también al activar
  el cierre grácil.
