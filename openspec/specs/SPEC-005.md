# SPEC-005 — Pantalla de Actividad con Historial de Ejercicios

## Status: Proposed

## Context

El `BottomNavigationBarItem` "Actividad" existe en el dashboard pero su pantalla
asociada no muestra contenido. Se requiere implementar una pantalla que liste
el historial de ejercicios completados.

## Requirements

### REQ-005-1 — Listado cronológico de ejercicios completados

La pantalla de Actividad DEBE mostrar una lista ordenada cronológicamente
(más reciente primero) de todos los ejercicios completados, con la siguiente
información por ítem: tipo de ejercicio, fecha y hora de finalización,
y duración en minutos/segundos.

### REQ-005-2 — Diferenciación visual por tipo de ejercicio

Cada ítem de la lista DEBE diferenciar visualmente (ícono y/o color) entre
ejercicio de respiración y ejercicio isométrico.

### REQ-005-3 — Estado vacío

Cuando no existan registros, la pantalla DEBE mostrar un estado vacío informativo
(mensaje + ícono) indicando que aún no se han completado ejercicios.

### REQ-005-4 — Consistencia con el tema Light/Dark

La pantalla DEBE responder al ThemeProvider de la app (ver SPEC-002).

## Acceptance Criteria

- DADO QUE el usuario ha completado 3 ejercicios,
  CUANDO navega a la pantalla Actividad,
  ENTONCES ve 3 ítems ordenados del más reciente al más antiguo.

- DADO QUE no se ha completado ningún ejercicio,
  CUANDO navega a la pantalla Actividad,
  ENTONCES ve un mensaje de estado vacío (sin errores ni lista vacía sin contexto).

## Technical Notes

- Consumir datos desde `DatabaseService.getAllLogs()`.
- Archivo afectado: `lib/screens/activity_screen.dart` (crear o completar).
- Depende de SPEC-004 (DatabaseService debe estar implementado).
