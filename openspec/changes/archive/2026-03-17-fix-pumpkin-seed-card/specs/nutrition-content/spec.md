## ADDED Requirements

### Requirement: Corrección del texto del Card de Semillas de Calabaza
El texto del Card al final de la pantalla de nutrición DEBE referirse a las Semillas de Calabaza, no a las Semillas de Sandía.

#### Scenario: Card muestra Semillas de Calabaza correctamente
- **WHEN** el usuario accede a la pantalla de nutrición
- **AND** visualiza el último Card de la sección "Cenas de Nitratos"
- **THEN** el título dice "Semillas de Calabaza"

### Requirement: Corrección del ícono del Card
El ícono del Card DEBE ser alegórico a la calabaza o a sus semillas.

#### Scenario: Card muestra ícono de calabaza
- **WHEN** el usuario visualiza el Card de semillas
- **THEN** el ícono es 🎃 (calabaza) en lugar de 🍉 (sandía)
