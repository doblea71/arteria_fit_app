# ADDED Requirements

## Requirement: Vibración en transiciones de fase del ejercicio de respiración

Al cambiar de fase (Inhalar → Retener → Exhalar → Inhalar) en breathing_screen.dart, el sistema DEBE disparar una vibración táctil corta.

### Scenario: Transición Inhalar a Retener

- **WHEN** el ejercicio de respiración cambia de fase Inhalar a Retener
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

### Scenario: Transición Retener a Exhalar

- **WHEN** el ejercicio de respiración cambia de fase Retener a Exhalar
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

### Scenario: Transición Exhalar a Inhalar (nuevo ciclo)

- **WHEN** el ejercicio de respiración cambia de fase Exhalar a Inhalar
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

## Requirement: Vibración en transiciones de fase del ejercicio isométrico

Al cambiar de fase (Contracción → Descanso o fases equivalentes) en isometrics_screen.dart, el sistema DEBE disparar una vibración táctil corta.

### Scenario: Transición Contracción a Descanso

- **WHEN** el ejercicio isométrico cambia de fase Contracción a Descanso
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

### Scenario: Transición Descanso a Contracción

- **WHEN** el ejercicio isométrico cambia de fase Descanso a Contracción
- **THEN** el dispositivo vibra brevemente (≤ 200ms)

## Requirement: Respeto a configuración de vibración del dispositivo

Si el dispositivo tiene la vibración desactivada a nivel de sistema, el sistema NO DEBE producir vibración ni lanzar errores.

### Scenario: Vibración desactivada no lanza excepción

- **WHEN** el dispositivo tiene la vibración desactivada y ocurre una transición de fase
- **THEN** la app no lanza excepciones y continúa normalmente
