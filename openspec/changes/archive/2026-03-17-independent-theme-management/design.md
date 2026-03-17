## Context

La aplicación Arteria Fit actualmente tiene un ThemeProvider que permite cambiar entre temas Light y Dark, pero presenta los siguientes problemas:

1. El tema inicial usa `ThemeMode.system` que depende del sistema operativo
2. No hay persistencia - al cerrar y abrir la app, vuelve al tema del sistema
3. Algunas pantallas hardcodean colores en lugar de usar el tema del provider
4. El cambio de tema requiere navegar entre pantallas para ver el efecto

## Goals / Non-Goals

**Goals:**
- Desacoplar completamente el tema de la app del sistema operativo
- Persistir la preferencia de tema entre sesiones usando SharedPreferences
- Asegurar cambio de tema inmediato en toda la app con una sola pulsación
- Mantener consistencia visual en todas las pantallas

**Non-Goals:**
- No se implementará cambio automático basado en hora del día
- No se creará modo "seguir al sistema" - solo Light/Dark manual

## Decisions

### DECISIÓN 1: Usar SharedPreferences para persistencia

**Alternativa considerada**: SQLite o Hive
**Rationale**: SharedPreferences es suficiente para datos simples de clave-valor y es más ligero

### DECISIÓN 2: theme_provider.dart como fuente única de verdad

**Alternativa considerada**: Usar InheritedWidget manual
**Rationale**: Riverpod ya está implementado en el proyecto y es más moderno y testeable

### DECISIÓN 3: Eliminar ThemeMode.system

**Alternativa considerada**: Mantener system como opción
**Rationale**: El requerimiento indica que la app debe ignorar el tema del SO completamente

## Risks / Trade-offs

- **[Riesgo]**: Si SharedPreferences falla, la app podría inicierse con tema por defecto
  - **Mitigación**: Usar valor por defecto seguro (Light) si falla la lectura

- **[Riesgo]**: Actualizar demasiadas pantallas simultáneamente podría causar lags
  - **Mitigación**: El cambio de tema en Flutter es eficiente gracias a InheritedWidget

## Migration Plan

1. Agregar dependencia `shared_preferences` a pubspec.yaml
2. Modificar ThemeProvider para cargar y guardar preferencia
3. Actualizar main.dart para usar solo ThemeMode.light o ThemeMode.dark
4. Actualizar cada screen para usar exclusivamente el ThemeProvider

## Open Questions

- ¿Debe el tema persistirse encriptado? No, no es información sensible.
