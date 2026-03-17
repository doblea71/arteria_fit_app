## ADDED Requirements

### Requirement: Tema independiente del sistema operativo
La app DEBE ignorar completamente la configuración de tema del sistema operativo y usar únicamente la preferencia almacenada en el ThemeProvider interno.

#### Scenario: App iniciada con preferencia Light guardada
- **WHEN** el usuario abre la app y tiene una preferencia Light almacenada
- **THEN** la app se muestra en modo Light independientemente del tema del SO

#### Scenario: App iniciada con preferencia Dark guardada
- **WHEN** el usuario abre la app y tiene una preferencia Dark almacenada
- **THEN** la app se muestra en modo Dark independientemente del tema del SO

### Requirement: Persistencia de preferencia de tema
La app DEBE guardar la preferencia de tema del usuario y recuperarla automáticamente al iniciar.

#### Scenario: Usuario cambia tema y cierra app
- **WHEN** el usuario cambia el tema a Dark y cierra la app
- **AND** vuelve a abrir la app
- **THEN** la app se muestra en tema Dark con la preferencia guardada

#### Scenario: Lectura de preferencia falla
- **WHEN** SharedPreferences no puede leer la preferencia guardada
- **THEN** la app usa tema Light por defecto

### Requirement: Cambio de tema inmediato
El toggle de tema DEBE aplicar el cambio en toda la app con una sola pulsación.

#### Scenario: Usuario toggla tema desde cualquier pantalla
- **WHEN** el usuario pulsa el botón de toggle en cualquier pantalla
- **THEN** todas las pantallas de la app cambian al tema seleccionado inmediatamente

### Requirement: Consistencia de tema en todas las pantallas
Todas las pantallas DEBEN responder al ThemeProvider de forma uniforme.

#### Scenario: Navegación entre pantallas mantiene tema
- **WHEN** el usuario está en tema Dark y navega del Dashboard a Nutrición
- **THEN** la pantalla de Nutrición también se muestra en tema Dark

#### Scenario: Pantallas no hardcodean colores
- **WHEN** se implementa el cambio
- **AND** las pantallas usan Theme.of(context) para colores
- **THEN** el tema se aplica correctamente sin necesidad de valores hardcodeados
