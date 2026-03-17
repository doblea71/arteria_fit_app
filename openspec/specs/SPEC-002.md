# SPEC-002 — Gestión de Tema Light/Dark Independiente del Sistema Operativo

## Status: Proposed

## Context

La app posee su propio toggle Light/Dark, pero actualmente varias pantallas adoptan
el tema del SO (modo oscuro del sistema), mientras otras ignoran dicho tema del SO.
Esto genera inconsistencia visual entre pantallas. Además el toggle propio de la app
requiere múltiples pulsaciones para aplicar el tema personalizado.

## Requirements

### REQ-002-1 — Desacoplar el tema de la app del tema del SO

La app DEBE ignorar la configuración de tema del sistema operativo. El tema
visual (Light/Dark) DEBE estar determinado únicamente por la preferencia
almacenada en el ThemeProvider interno de la app.

### REQ-002-2 — Consistencia de tema en todas las pantallas

Todas las pantallas (incluidas `dashboard_screen.dart`, `isometrics_screen.dart`
y todas las demás) DEBEN responder al mismo ThemeProvider, produciendo una
experiencia visual uniforme.

### REQ-002-3 — Persistencia de la preferencia de tema

La preferencia del tema seleccionado por el usuario DEBE persistir entre sesiones
la app, almacenándose en SharedPreferences o equivalente.

### REQ-002-4 — Respuesta inmediata al toggle de tema

El toggle Light/Dark DEBE aplicar el cambio de tema en toda la app en una
única pulsación, sin necesidad de pulsaciones repetidas.

## Acceptance Criteria

- DADO QUE el SO tiene el modo oscuro activo,
  CUANDO se abre la app con preferencia de tema Light guardada,
  ENTONCES TODAS las pantallas se muestran con tema Light.

- DADO QUE el usuario pulsa el toggle una vez para cambiar a Dark,
  CUANDO navega a cualquier pantalla de la app,
  ENTONCES todas las pantallas reflejan el tema Dark inmediatamente.

- DADO QUE el usuario cierra y reabre la app,
  CUANDO se carga la pantalla inicial,
  ENTONCES se muestra el último tema seleccionado por el usuario.

## Technical Notes

- En `MaterialApp`, establecer `themeMode: ThemeMode.light` o `ThemeMode.dark`
  desde el ThemeProvider, y eliminar cualquier uso de `MediaQuery.platformBrightness`
  o `ThemeMode.system`.
- Auditar cada pantalla que use `Theme.of(context).brightness` de forma aislada
  y reemplazar por el valor del ThemeProvider.
- Archivos afectados: `main.dart`, `providers/theme_provider.dart`,
  todas las `*_screen.dart`.
