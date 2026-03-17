## Why

El BottomNavigationBarItem "Actividad" existe en el dashboard pero su pantalla asociada no muestra contenido. Los usuarios necesitan ver un historial de sus ejercicios completados para mantener seguimiento de su progreso cardiovascular.

## What Changes

- Crear pantalla de Actividad que muestre lista de ejercicios completados
- Mostrar información: tipo de ejercicio, fecha/hora, duración
- Diferenciar visualmente entre respiración e isométricos con iconos y colores
- Mostrar estado vacío cuando no hay registros
- Mantener consistencia con tema Light/Dark

## Capabilities

### New Capabilities

- **activity-history**: Pantalla de historial de ejercicios que lista todos los ejercicios completados ordenados cronológicamente

### Modified Capabilities

- Ninguno - es una funcionalidad nueva

## Impact

- **Archivos nuevos**: `lib/features/activity/activity_screen.dart`
- **Archivos modificados**: `lib/core/router/app_router.dart` (agregar ruta)
- **Dependencias nuevas**: Ninguna
- **Breaking changes**: Ninguno
