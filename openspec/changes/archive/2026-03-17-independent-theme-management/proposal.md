## Why

La aplicación Arteria Fit necesita un sistema de tema Light/Dark que funcione de forma independiente al sistema operativo. Actualmente, el toggle de tema de la app no funciona consistentemente - algunas pantallas ignoran la configuración y el tema requiere múltiples pulsaciones para aplicarse. Esto genera una experiencia de usuario inconsistente.

## What Changes

- Implementar ThemeProvider que ignore completamente el tema del sistema operativo
- Agregar persistencia de preferencia de tema usando SharedPreferences
- Asegurar que todas las pantallas respondan al ThemeProvider de forma inmediata
- Eliminar el uso de `ThemeMode.system` y `MediaQuery.platformBrightness`

## Capabilities

### New Capabilities

- **independent-theme-management**: Sistema de gestión de tema que desacopla el tema de la app del SO y persiste la preferencia del usuario entre sesiones

### Modified Capabilities

- Ninguno - es una funcionalidad nueva

## Impact

- **Archivos afectados**: `lib/main.dart`, `lib/core/providers/theme_provider.dart`, `lib/features/dashboard/dashboard_screen.dart`, `lib/features/breathing/breathing_screen.dart`, `lib/features/isometrics/isometrics_screen.dart`, `lib/features/nutrition/nutrition_screen.dart`
- **Dependencias nuevas**: `shared_preferences` (para persistencia)
- **Breaking changes**: Ninguno - es backward compatible
