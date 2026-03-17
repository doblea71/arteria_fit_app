## Context

Actualmente, el widget `buildProgressCard()` en el dashboard muestra datos hard-coded (60% de progreso). No existe persistencia de los ejercicios completados ni posibilidad de que el usuario configure sus metas diarias.

## Goals / Non-Goals

**Goals:**
- Implementar base de datos SQLite para registrar ejercicios completados
- Permitir registro automático al finalizar ejercicios
- Crear pantalla de Ajustes para configurar metas diarias
- Mostrar progreso real vs meta en el dashboard

**Non-Goals:**
- No implementar autenticación de usuario
- No implementar sincronización en la nube
- No crear estadísticas históricas complejas

## Decisions

### DECISIÓN 1: Usar SQLite (sqflite) en lugar de SharedPreferences

**Alternativa considerada**: SharedPreferences
**Rationale**: SQLite permite consultas complejas, filtrado por fecha, y es más apropiado para datos estructurados como logs de ejercicios. Además, permite futuras expansiones.

### DECISIÓN 2: Crear DatabaseService como singleton

**Alternativa considerada**: Instancia global o Provider
**Rationale**: Un singleton garantiza una única conexión a la base de datos y acceso global sin necesidad de Provider adicional.

### DECISIÓN 3: Almacenar metas en SQLite junto con logs

**Alternativa considerada**: SharedPreferences para metas
**Rationale**: Mantener todos los datos en SQLite simplifica la arquitectura y permite consultas unificadas.

## Risks / Trade-offs

- **[Riesgo]**: La base de datos puede crecer significativamente con el tiempo
  - **Mitigación**: Los logs antiguos no afectan el rendimiento de las consultas de "hoy"

- **[Riesgo]**: Fallo en la inserción del log al completar ejercicio
  - **Mitigación**: Mostrar mensaje de error al usuario y permitir reintento

## Migration Plan

1. Agregar dependencias sqflite y path_provider
2. Crear DatabaseService con esquema de base de datos
3. Modificar breathing_screen.dart para registrar al completar
4. Modificar isometrics_screen.dart para registrar al completar
5. Crear settings_screen.dart para configurar metas
6. Actualizar dashboard_screen.dart para mostrar progreso real

## Open Questions

- ¿Se necesita mostrar historial de días anteriores? Por ahora no, solo "hoy".
