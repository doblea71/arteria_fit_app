# SPEC-004 — Seguimiento de Objetivos Diarios con SQLite

## Status: Proposed

## Context

El widget `buildProgressCard()` del dashboard muestra datos estáticos (hard-coded).
Se requiere implementar persistencia real que registre cuántas veces se completan
los ejercicios y permita al usuario definir metas diarias desde la pantalla de Ajustes.

## Requirements

### REQ-004-1 — Esquema de base de datos SQLite para registros de ejercicios

El sistema DEBE crear y gestionar una tabla `exercise_log` en SQLite con al
menos los campos: `id`, `exercise_type` (breathing | isometric), `completed_at`
(timestamp), `duration_seconds`.

### REQ-004-2 — Registro automático al completar un ejercicio

Al finalizar exitosamente un ejercicio de respiración o isométrico, el sistema
DEBE insertar automáticamente un registro en `exercise_log`.

### REQ-004-3 — Configuración de metas diarias desde Ajustes

En la pantalla "Ajustes" (accesible desde `BottomNavigationBar`), el sistema
DEBE presentar campos de texto para que el usuario defina el número máximo
diario de repeticiones por tipo de ejercicio.

### REQ-004-4 — Persistencia de metas diarias

Las metas diarias configuradas por el usuario DEBEN persistir entre sesiones,
almacenándose en SQLite o SharedPreferences.

### REQ-004-5 — Actualización reactiva del widget buildProgressCard()

El widget `buildProgressCard()` DEBE mostrar dinámicamente: el número de ejercicios
completados hoy vs. la meta diaria configurada, para cada tipo de ejercicio.

## Acceptance Criteria

- DADO QUE el usuario completa un ejercicio de respiración,
  CUANDO finaliza el ejercicio,
  ENTONCES se guarda un registro en `exercise_log` con `exercise_type = 'breathing'`
  y el timestamp actual.

- DADO QUE el usuario establece meta diaria de respiración = 5 en Ajustes,
  CUANDO el dashboard se recarga,
  ENTONCES `buildProgressCard()` muestra el progreso actual sobre 5.

- DADO QUE el usuario ha completado 3 de 5 ejercicios de respiración hoy,
  CUANDO visualiza el dashboard,
  ENTONCES el card muestra "3 / 5" para respiración.

## Technical Notes

- Usar el paquete `sqflite` con `path_provider`.
- Crear `services/database_service.dart` con métodos:
  `insertLog()`, `getLogsToday()`, `getDailyGoal()`, `setDailyGoal()`.
- Archivos afectados: `dashboard_screen.dart`, `settings_screen.dart`,
  `breathing_screen.dart`, `isometrics_screen.dart`,
  nuevo `services/database_service.dart`.
