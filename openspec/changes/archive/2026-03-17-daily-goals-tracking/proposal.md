## Why

El widget `buildProgressCard()` del dashboard actualmente muestra datos estáticos (hard-coded). Los usuarios necesitan un sistema que registre sus ejercicios completados y les permita establecer metas diarias personalizadas para mejorar su salud cardiovascular.

## What Changes

- Crear servicio de base de datos SQLite para almacenar registros de ejercicios
- Implementar registro automático al completar ejercicios de respiración e isométricos
- Crear pantalla de Ajustes para configurar metas diarias
- Actualizar el widget buildProgressCard() para mostrar progreso real vs meta
- Persistir las metas diarias entre sesiones

## Capabilities

### New Capabilities

- **daily-goals-tracking**: Sistema de seguimiento de objetivos diarios con SQLite que registra ejercicios completados y permite al usuario definir metas diarias

### Modified Capabilities

- Ninguno - es una funcionalidad nueva.

## Impact

- **Archivos nuevos**:
  - `lib/core/services/database_service.dart`
  - `lib/features/settings/settings_screen.dart`
- **Archivos modificados**:
  - `lib/features/dashboard/dashboard_screen.dart`
  - `lib/features/breathing/breathing_screen.dart`
  - `lib/features/isometrics/isometrics_screen.dart`
- **Dependencias nuevas**: `sqflite`, `path_provider`
- **Breaking changes**: Ninguno
