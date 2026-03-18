## ADDED Requirements

### Requirement: Número regresivo en la fase Inhalar
Durante la fase "Inhalar", el sistema DEBE mostrar un número regresivo que comience en 4 y decremente en 1 cada segundo (4 → 3 → 2 → 1), desapareciendo al completarse la fase.

#### Scenario: Contador muestra 4 al iniciar Inhalar
- **WHEN** la fase Inhalar inicia
- **THEN** se muestra el número 4 decrementando cada segundo

### Requirement: Número regresivo en la fase Mantener
Durante la fase "Mantener", el sistema DEBE mostrar un número regresivo que comience en 7 y decremente en 1 cada segundo.

#### Scenario: Contador muestra 7 al iniciar Mantener
- **WHEN** la fase Mantener inicia
- **THEN** se muestra el número 7 decrementando cada segundo

### Requirement: Número regresivo en la fase Exhalar
Durante la fase "Exhalar", el sistema DEBE mostrar un número regresivo que comience en 8 y decremente en 1 cada segundo.

#### Scenario: Contador muestra 8 al iniciar Exhalar
- **WHEN** la fase Exhalar inicia
- **THEN** se muestra el número 8 decrementando cada segundo

### Requirement: Posicionamiento detrás de la animación existente
El número DEBE renderizarse en una capa inferior (z-order) a la animación actual.

#### Scenario: Animación visible sobre el número
- **WHEN** el número y la animación se renderizan simultáneamente
- **THEN** la animación es visible en primer plano

### Requirement: Estilo semi-transparente del número
El número DEBE renderizarse con una opacidad entre 0.15 y 0.25.

#### Scenario: Número semi-transparente
- **WHEN** el contador se muestra
- **THEN** tiene opacidad entre 0.15 y 0.25

### Requirement: Reset del contador al cambiar de fase
Al producirse una transición de fase, el número DEBE cambiar instantáneamente al valor inicial de la nueva fase.

#### Scenario: Reset al cambiar de Inhalar a Mantener
- **WHEN** la fase cambia de Inhalar a Mantener
- **THEN** el número cambia instantáneamente a 7

### Requirement: Consistencia con tema Light/Dark
El color del número DEBE derivarse del tema activo de la app.

#### Scenario: Modo Light usa color oscuro
- **WHEN** la app está en modo Light
- **THEN** el número usa color oscuro semi-transparente

#### Scenario: Modo Dark usa color claro
- **WHEN** la app está en modo Dark
- **THEN** el número usa color claro semi-transparente

### Requirement: Compatibilidad con cierre grácil de SPEC-001
Durante la fase "Exhalar" forzada al final del temporizador global, el contador DEBE funcionar normalmente.

#### Scenario: Contador funciona durante cierre grácil
- **WHEN** se activa el cierre grácil de SPEC-001
- **THEN** el Exhalar final muestra contador de 8 a 1
