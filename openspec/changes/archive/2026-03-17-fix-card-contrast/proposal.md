## Why

Los widgets de cards en las pantallas de Nutrición, Isométricos y Respiración usan colores hardcodeados (fondo blanco con texto negro) que no respetan el tema Light/Dark de la app. Esto causa bajo contraste visual, especialmente en modo Dark donde el texto negro sobre fondo blanco es ilegible.

## What Changes

- Reemplazar colores hardcodeados en `buildFoodCard()` de nutrition_screen.dart
- Reemplazar colores hardcodeados en los widgets de isometrics_screen.dart
- Reemplazar colores hardcodeados en los widgets de breathing_screen.dart
- Usar Theme.of(context) para que los cards respondan al tema automáticamente

## Capabilities

### New Capabilities

- **card-contrast-fix**: Corrección de contraste en cards para cumplir con WCAG AA (4.5:1)

### Modified Capabilities

- Ninguno - es una corrección de la implementación existente

## Impact

- **Archivos afectados**:
  - `lib/features/nutrition/nutrition_screen.dart`
  - `lib/features/isometrics/isometrics_screen.dart`
  - `lib/features/breathing/breathing_screen.dart`
- **Dependencias nuevas**: Ninguna
- **Breaking changes**: Ninguno
