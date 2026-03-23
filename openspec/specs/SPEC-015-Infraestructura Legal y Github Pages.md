# SPEC-015 — Infraestructura Legal y GitHub Pages para Monetización

## Status: Proposed

## Context

Antes de implementar cualquier funcionalidad de monetización o consentimiento RGPD, es **imperativo** contar con:
1. Documentos legales públicos (Política de Privacidad y Términos de Uso)
2. Una ubicación accesible públicamente para alojar estos documentos

La app se distribuye actualmente vía GitHub Release, sin cuenta de Google Play ni Apple Store.
**Desarrollador:** Angel Emiro Antunez Villasmil (DevDoblea)

**Restricciones:**
- Sin cuenta de desarrollador en tiendas
- Sin documentos legales existentes
- GitHub Pages no configurado

## Requirements

### REQ-015-1 — Crear GitHub Pages para Documentos Legales

El sistema DEBE tener un sitio GitHub Pages configurado para alojar los documentos legales.

- Crear rama `gh-pages` o usar repositorio separado
- Estructura: `index.html`, `privacy-policy.html`, `terms-of-use.html`
- URL accesible: `https://devdoblea.github.io/arteria_fit_app/` o similar
- Certificado SSL válido (HTTPS)

### REQ-015-2 — Redactar Política de Privacidad

El sistema DEBE tener una Política de Privacidad conforme al RGPD con:

| Sección | Contenido |
|---------|-----------|
| Identidad del responsable | Angel Emiro Antunez Villasmil (DevDoblea) |
| Datos tratados | Lista de datos almacenados localmente |
| Finalidad del tratamiento | Funcionamiento de la app de salud cardiovascular |
| Base legal | Consentimiento del usuario |
| Destinatarios | Ninguno (datos 100% locales) - placeholder para Infatica |
| Duración del almacenamiento | Hasta que el usuario solicite eliminación |
| Derechos del usuario | Acceso, rectificación, supresión, portabilidad, oposición |
| Contacto RGPD | Email para solicitudes |
| SDKs de terceros | Placeholder para Infatica (si aplica) |

### REQ-015-3 — Redactar Términos de Uso

El sistema DEBE tener Términos de Uso que incluyan:

| Sección | Contenido |
|---------|-----------|
| Objeto | Descripción de la app y su propósito |
| Exención de responsabilidad | No sustituye consejo médico profesional |
| Licencia de uso | Gratuita, sin garantías |
| Propiedad intelectual | Derechos sobre la app |
| Modificaciones | Derecho a cambiar términos |
| Jurisdicción | Aplicable |

### REQ-015-4 — Configurar URLs en la Aplicación Flutter

El sistema DEBE incluir constantes para las URLs de documentos legales.

**Archivo:** `lib/core/constants/legal_constants.dart`

```dart
class LegalConstants {
  static const String privacyPolicyUrl = 'https://devdoblea.github.io/arteria_fit_app/privacy-policy';
  static const String termsOfUseUrl = 'https://devdoblea.github.io/arteria_fit_app/terms-of-use';
  static const String developerName = 'Angel Emiro Antunez Villasmil (DevDoblea)';
  static const String contactEmail = 'privacy@arteriafit.com'; // Definir
}
```

## Acceptance Criteria

- DADO QUE el usuario necesita acceder a la Política de Privacidad,
  CUANDO abre el link desde la app,
  ENTONCES la URL carga correctamente en HTTPS.

- DADO QUE el usuario necesita acceder a los Términos de Uso,
  CUANDO abre el link desde la app,
  ENTONCES la URL carga correctamente en HTTPS.

- DADO QUE una autoridad solicita documentación RGPD,
  CUANDO se accede a GitHub Pages,
  ENTONCES todos los documentos legales están disponibles públicamente.

## Dependencies

**Este SPEC bloquea:**
- SPEC-016 (Centro de Consentimiento)
- SPEC-017 (Sistema de Donaciones)
- SPEC-018 (Investigación Infatica)

**Este SPEC es bloqueado por:**
- Ninguno (puede iniciarse inmediatamente)

## Technical Notes

### Opciones de Email de Contacto RGPD
- Crear email dedicado (`privacy@arteriafit.com`)
- Usar email personal con alias
- Usar GitHub Discussions como alternativa

### Hosting Alternativo (si GitHub Pages no es viable)
- Netlify (gratuito)
- Vercel (gratuito)
- Cloudflare Pages (gratuito)

## Deliverables

1. Repositorio GitHub Pages configurado y accesible
2. Política de Privacidad publicada
3. Términos de Uso publicados
4. Constantes de URLs en Flutter (`legal_constants.dart`)
5. Email de contacto RGPD definido

## Estimate: 4-6 hours