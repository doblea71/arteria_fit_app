## MODIFIED Requirements

### Requirement: Vibración en transiciones de fase del ejercicio de respiración
Al cambiar de fase (Inhalar → Retener → Exhalar → Inhalar) en breathing_screen.dart, el sistema DEBE disparar una vibración táctil corta.

#### Scenario: Transición Inhalar a Retener
- **WHEN** el ejercicio de respiración cambia de fase Inhalar a Retener
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

#### Scenario: Transición Retener a Exhalar
- **WHEN** el ejercicio de respiración cambia de fase Retener a Exhalar
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

#### Scenario: Transición Exhalar a Inhalar (nuevo ciclo)
- **WHEN** el ejercicio de respiración cambia de fase Exhalar a Inhalar
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

#### Scenario: Vibración al inicio de fase Inhalar
- **WHEN** el ciclo de respiración inicia la fase Inhalar
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

## ADDED Requirements

### Requirement: Vibración después de setState
La vibración DEBE dispararse DESPUÉS de actualizar el estado de la fase, para que coincida con lo que ve el usuario.

#### Scenario: Vibración después de cambio de estado
- **WHEN** se ejecuta setState para cambiar la fase
- **THEN** la vibración se dispara después del setState

### Requirement: Sin vibración en cierre gracioso
Cuando se activa el cierre gracioso (SPEC-001), NO DEBE dispararse vibración para la fase Inhalar truncada.

#### Scenario: Cierre gracioso sin vibración de Inhalar
- **WHEN** el temporizador global expira y se activa el cierre gracioso
- **THEN** no se dispara vibración para la fase Inhalar que no se ejecuta
