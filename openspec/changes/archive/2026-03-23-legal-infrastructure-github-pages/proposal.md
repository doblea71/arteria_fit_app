## Why

Para cumplir con el RGPD y preparar la app para monetización (donaciones), es necesario contar con documentos legales públicos (Política de Privacidad y Términos de Uso) alojados en GitHub Pages. Sin esta infraestructura, no se pueden implementar funcionalidades de consentimiento ni sistemas de donación.

## What Changes

- Configurar GitHub Pages en el repositorio `devdoblea/arteria_fit_app` usando github cli instalado en local
- Crear y publicar Política de Privacidad conforme RGPD
- Crear y publicar Términos de Uso
- Añadir constantes en Flutter para URLs de documentos legales
- Definir email de contacto RGPD

## Capabilities

### New Capabilities

- `github-pages-legal`: Infraestructura GitHub Pages para alojar documentos legales con URLs HTTPS accesibles públicamente
- `privacy-policy`: Política de Privacidad conforme RGPD con información del responsable, datos tratados, derechos del usuario y contacto
- `terms-of-use`: Términos de Uso incluyendo exención de responsabilidad médica, licencia de uso y jurisdicción

### Modified Capabilities

- Ninguno

## Impact

- Nuevo: Directorio `docs/` con archivos HTML legales
- Nuevo: Rama `gh-pages` en GitHub
- Nuevo: `lib/core/constants/legal_constants.dart` en Flutter
- Dependencias bloqueadas: SPEC-016 (Centro de Consentimiento), SPEC-017 (Sistema de Donaciones), SPEC-018 (Investigación Infatica)
