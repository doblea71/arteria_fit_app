## ADDED Requirements

### Requirement: Contraste adecuado en modo Light
En modo Light, los cards DEBEN usar una combinación de colores que cumpla con un ratio de contraste mínimo de 4.5:1 (WCAG AA) entre fondo y texto.

#### Scenario: Card de Nutrición en modo Light
- **WHEN** la app está en modo Light y se visualiza el card de nutrición
- **THEN** el fondo usa color claro del tema y el texto es oscuro con contraste ≥ 4.5:1

#### Scenario: Card de Isométricos en modo Light
- **WHEN** la app está en modo Light y se visualiza el card de isométricos
- **THEN** el fondo usa color claro del tema y el texto es oscuro con contraste ≥ 4.5:1

#### Scenario: Card de Respiración en modo Light
- **WHEN** la app está en modo Light y se visualiza el card de respiración
- **THEN** el fondo usa color claro del tema y el texto es oscuro con contraste ≥ 4.5:1

### Requirement: Contraste adecuado en modo Dark
En modo Dark, los cards DEBEN usar fondo oscuro con texto claro, manteniendo el mismo ratio mínimo de 4.5:1.

#### Scenario: Card de Nutrición en modo Dark
- **WHEN** la app está en modo Dark y se visualiza el card de nutrición
- **THEN** el fondo usa color oscuro del tema y el texto es claro con contraste ≥ 4.5:1

#### Scenario: Card de Isométricos en modo Dark
- **WHEN** la app está en modo Dark y se visualiza el card de isométricos
- **THEN** el fondo usa color oscuro del tema y el texto es claro con contraste ≥ 4.5:1

#### Scenario: Card de Respiración en modo Dark
- **WHEN** la app está en modo Dark y se visualiza el card de respiración
- **THEN** el fondo usa color oscuro del tema y el texto es claro con contraste ≥ 4.5:1

### Requirement: Colores derivados del Theme
Los colores de los cards DEBEN derivarse de Theme.of(context) para que respondan automáticamente al toggle Light/Dark.

#### Scenario: Cambio de tema actualiza colors
- **WHEN** el usuario cambia el tema usando el toggle
- **AND** se renderiza cualquier card
- **THEN** el card adopta inmediatamente los colores del nuevo tema

#### Scenario: Navegación mantiene tema correcto
- **WHEN** el usuario navega entre pantallas manteniendo un tema
- **THEN** todos los cards reflejan los colores correctos del tema activo
