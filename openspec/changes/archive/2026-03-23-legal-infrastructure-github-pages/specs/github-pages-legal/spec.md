# GitHub Pages Legal Infrastructure

## Status: Proposed

## ADDED Requirements

### Requirement: GitHub Pages enabled

El sistema DEBE tener GitHub Pages habilitado en el repositorio `devdoblea/arteria_fit_app` sirviendo desde el directorio `docs/`.

#### Scenario: GitHub Pages serves HTTPS
- **WHEN** se accede a `https://devdoblea.github.io/arteria_fit_app/`
- **THEN** el servidor responde con HTTP 200 y contenido HTML

### Requirement: Estructura de documentos

El sistema DEBE servir los siguientes archivos desde GitHub Pages:
- `index.html` - Página principal de redirection o landing
- `privacy-policy.html` - Política de Privacidad
- `terms-of-use.html` - Términos de Uso

#### Scenario: All legal documents accessible
- **WHEN** el usuario accede a cada URL de documento legal
- **THEN** el contenido se muestra correctamente en el navegador

### Requirement: URLs de Flutter configuradas

El sistema DEBE incluir constantes en `lib/core/constants/legal_constants.dart` con las URLs de los documentos legales.

#### Scenario: Flutter imports legal constants
- **WHEN** código Flutter importa `legal_constants.dart`
- **THEN** puede acceder a `privacyPolicyUrl` y `termsOfUseUrl`

#### Scenario: URLs son HTTPS
- **WHEN** se usan las URLs de documentos legales
- **THEN** todas las URLs usan protocolo HTTPS
