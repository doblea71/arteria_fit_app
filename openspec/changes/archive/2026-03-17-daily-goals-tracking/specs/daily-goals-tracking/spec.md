## ADDED Requirements

### Requirement: Esquema de base de datos SQLite para registros
El sistema DEBE crear y gestionar una tabla `exercise_log` en SQLite con al menos los campos: `id`, `exercise_type` (breathing | isometric), `completed_at` (timestamp), `duration_seconds`.

#### Scenario: Tabla exercise_log creada al iniciar app
- **WHEN** la app se inicia por primera vez
- **THEN** se crea la tabla `exercise_log` automáticamente

### Requirement: Registro automático al completar ejercicio de respiración
Al finalizar exitosamente un ejercicio de respiración, el sistema DEBE insertar automáticamente un registro en `exercise_log` con `exercise_type = 'breathing'`.

#### Scenario: Usuario completa ejercicio de respiración
- **WHEN** el usuario completa una sesión de respiración (timer llega a 0)
- **THEN** se guarda un registro en `exercise_log` con exercise_type='breathing'

### Requirement: Registro automático al completar ejercicio isométrico
Al finalizar exitosamente un ejercicio isométrico, el sistema DEBE insertar automáticamente un registro en `exercise_log` con `exercise_type = 'isometric'`.

#### Scenario: Usuario completa ejercicio isométrico
- **WHEN** el usuario completa los 4 sets de ejercicios isométricos
- **THEN** se guarda un registro en `exercise_log` con exercise_type='isometric'

### Requirement: Configuración de metas diarias desde Ajustes
En la pantalla "Ajustes" (accesible desde BottomNavigationBar), el sistema DEBE presentar campos para que el usuario defina el número máximo diario de repeticiones por tipo de ejercicio.

#### Scenario: Usuario establece meta diaria
- **WHEN** el usuario ingresa un número en el campo de meta de respiración
- **AND** guarda los cambios
- **THEN** la meta se almacena y persiste entre sesiones

### Requirement: Persistencia de metas diarias
Las metas diarias configuradas por el usuario DEBEN persistir entre sesiones, almacenándose en SQLite.

#### Scenario: App reiniciada mantiene metas
- **WHEN** el usuario cierra y vuelve a abrir la app
- **THEN** las metas diarias configuradas anteriormente se mantienen

### Requirement: Actualización reactiva del widget buildProgressCard()
El widget `buildProgressCard()` DEBE mostrar dinámicamente: el número de ejercicios completados hoy vs. la meta diaria configurada, para cada tipo de ejercicio.

#### Scenario: Dashboard muestra progreso real
- **WHEN** el usuario tiene 3 ejercicios de respiración completados hoy
- **AND** su meta diaria es 5
- **THEN** el dashboard muestra "3 / 5" para respiración

#### Scenario: Dashboard muestra progreso vacío
- **WHEN** el usuario no ha completado ningún ejercicio hoy
- **AND** su meta diaria es 5
- **THEN** el dashboard muestra "0 / 5" para cada tipo
