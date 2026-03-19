## ADDED Requirements

### Requirement: Activación del wake lock al iniciar ejercicio
El sistema DEBE activar el wake lock del dispositivo (mantener pantalla encendida) cuando el usuario inicia un ejercicio de respiración o isométrico.

#### Scenario: Wake lock activa en respiración
- **WHEN** el usuario pulsa iniciar en respiración
- **THEN** la pantalla permanece encendida

#### Scenario: Wake lock activa en isométricos
- **WHEN** el usuario pulsa iniciar en isométricos
- **THEN** la pantalla permanece encendida

### Requirement: Desactivación del wake lock al finalizar
El sistema DEBE liberar el wake lock cuando el ejercicio se completa, se detiene manualmente, o el usuario navega fuera.

#### Scenario: Wake lock liberado al completar ejercicio
- **WHEN** el ejercicio se completa normalmente
- **THEN** el wake lock se libera

#### Scenario: Wake lock liberado al detener manualmente
- **WHEN** el usuario pulsa detener
- **THEN** el wake lock se libera

### Requirement: Liberación en ciclo de vida de la app
Si la app pasa a segundo plano, el wake lock DEBE liberarse. Al volver con ejercicio activo, DEBE reactivarse.

#### Scenario: Wake lock liberado al ir a background
- **WHEN** la app pasa a AppLifecycleState.paused
- **THEN** el wake lock se libera

#### Scenario: Wake lock reactivado al volver a foreground
- **WHEN** la app vuelve a AppLifecycleState.resumed con ejercicio activo
- **THEN** el wake lock se reactiva

### Requirement: Liberación garantizada en dispose
El wake lock DEBE liberarse en dispose() para garantizar que no quede activo.

#### Scenario: Wake lock liberado en dispose
- **WHEN** el widget se destruye
- **THEN** el wake lock se libera

### Requirement: Sin efectos en pantallas no-ejercicio
El sistema NO DEBE mantener wake lock en dashboard, nutrición, ajustes o actividad.

#### Scenario: Dashboard sin wake lock
- **WHEN** el usuario está en dashboard
- **THEN** el wake lock no está activo
