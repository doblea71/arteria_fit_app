# SPEC-006 — Corrección de Contraste en Cards (Nutrición, Isométricos, Respiración)

## Status: Proposed

## Context

Los widgets `buildFoodCard()`, `buildIsometricCard()` y `buildBreathingCard()`
presentan fondo blanco con texto negro, resultando en bajo contraste visual.
Se requiere mejorar el contraste respetando los temas Light/Dark de la app.

## Requirements

### REQ-006-1 — Contraste adecuado en modo Light

En modo Light, los cards DEBEN usar una combinación de colores que cumpla con
un ratio de contraste mínimo de 4.5:1 (WCAG AA) entre fondo y texto.

### REQ-006-2 — Contraste adecuado en modo Dark

En modo Dark, los cards DEBEN usar fondo oscuro (ej. Color del tema `cardColor`
o `surface`) con texto claro, manteniendo el mismo ratio mínimo de 4.5:1.

### REQ-006-3 — Uso de colores del ThemeProvider

Los colores de los cards DEBEN derivarse de `Theme.of(context)` para que
respondan automáticamente al toggle Light/Dark (ver SPEC-002).

## Acceptance Criteria

- DADO QUE la app está en modo Light,
  CUANDO el usuario visualiza cualquiera de los tres cards,
  ENTONCES el contraste fondo/texto es ≥ 4.5:1.

- DADO QUE la app está en modo Dark,
  CUANDO el usuario visualiza cualquiera de los tres cards,
  ENTONCES el fondo es oscuro y el texto es claro con contraste ≥ 4.5:1.

- DADO QUE el usuario cambia el tema con el toggle,
  CUANDO se renderiza el card,
  ENTONCES el card adopta inmediatamente los colores del nuevo tema.

## Technical Notes

- Reemplazar colores hardcoded (`Colors.white`, `Colors.black`) por
  `Theme.of(context).cardColor` y `Theme.of(context).colorScheme.onSurface`.
- Archivos afectados: `nutrition_screen.dart`, `isometrics_screen.dart`, `breathing_screen.dart`.
