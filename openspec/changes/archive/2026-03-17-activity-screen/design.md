## Context

El BottomNavigationBar tiene un ítem "Actividad" que actualmente no muestra ninguna pantalla. El DatabaseService ya está implementado (SPEC-004), por lo que podemos consumir los datos de ejercicios completados.

## Goals / Non-Goals

**Goals:**
- Mostrar lista cronológica de ejercicios completados
- Diferenciar visualmente respiración de isométricos
- Mostrar estado vacío cuando no hay registros
- Mantener ThemeProvider para Light/Dark

**Non-Goals:**
- No implementar filtros de fecha
- No implementar paginación
- No mostrar estadísticas avanzadas

## Decisions

### DECISIÓN 1: Usar ListView.builder para mejor rendimiento

**Alternativa considerada**: Column con children
**Rationale**: ListView.builder es más eficiente para listas que pueden crecer

### DECISIÓN 2: Obtener todos los logs y ordenar en Dart

**Alternativa considerada**: Ordenar en SQLite
**Rationale**: Simplifica el código y el volumen de datos es pequeño

## Risks / Trade-offs

- **[Riesgo]**: La lista puede crecer mucho con el tiempo
  - **Mitigación**: Future enhancement con paginación si es necesario

## Migration Plan

1. Agregar método getAllLogs() a DatabaseService
2. Crear ActivityScreen
3. Agregar ruta en app_router.dart
4. Conectar navegación desde BottomNavigationBar

## Open Questions

- Ninguno - la implementación es directa
