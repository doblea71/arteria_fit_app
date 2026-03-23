## 1. Configurar GitHub Pages

- [x] 1.1 Habilitar GitHub Pages en el repositorio `doblea71/arteria_fit_app` (Settings → Pages → Source: Deploy from a branch, branch: main, folder: /docs)
- [x] 1.2 Verificar que `https://doblea71.github.io/arteria_fit_app/` responde correctamente

## 2. Crear estructura de documentos legales

- [x] 2.1 Crear directorio `docs/` en la raíz del proyecto
- [x] 2.2 Crear `docs/index.html` con landing page básico
- [x] 2.3 Crear `docs/privacy-policy.html` con Política de Privacidad RGPD
- [x] 2.4 Crear `docs/terms-of-use.html` con Términos de Uso

## 3. Implementar Política de Privacidad

- [x] 3.1 Redactar sección "Responsable del Tratamiento" (Angel Emiro Antunez Villasmil - DevDoblea)
- [x] 3.2 Redactar sección "Datos Tratados" (presión arterial, frecuencia cardíaca, preferencias)
- [x] 3.3 Redactar sección "Finalidad del Tratamiento"
- [x] 3.4 Redactar sección "Base Legal" (consentimiento)
- [x] 3.5 Redactar sección "Destinatarios" (ninguno - datos locales)
- [x] 3.6 Redactar sección "Duración del Almacenamiento"
- [x] 3.7 Redactar sección "Derechos del Usuario" (ARCO+)
- [x] 3.8 Redactar sección "Contacto RGPD" (email)
- [x] 3.9 Añadir placeholder para Infatica SDK si aplica

## 4. Implementar Términos de Uso

- [x] 4.1 Redactar sección "Objeto" (descripción de Arteria Fit)
- [x] 4.2 Redactar sección "Exención de Responsabilidad Médica"
- [x] 4.3 Redactar sección "Licencia de Uso" (gratuita, sin garantías)
- [x] 4.4 Redactar sección "Propiedad Intelectual"
- [x] 4.5 Redactar sección "Modificaciones" (derecho a cambiar términos)
- [x] 4.6 Redactar sección "Jurisdicción" (España)

## 5. Integrar URLs en Flutter

- [x] 5.1 Crear `lib/core/constants/legal_constants.dart`
- [x] 5.2 Definir `privacyPolicyUrl` con URL HTTPS de GitHub Pages
- [x] 5.3 Definir `termsOfUseUrl` con URL HTTPS de GitHub Pages
- [x] 5.4 Definir `developerName` y `contactEmail`
- [x] 5.5 Añadir archivo a exports en `lib/core/constants/constants.dart` (si existe)

## 6. Verificación y commit

- [x] 6.1 Verificar que todas las URLs HTTPS funcionan correctamente
- [x] 6.2 Actualizar versión en `pubspec.yaml` (PATCH +1, BUILD +1)
- [x] 6.3 Crear commit con los cambios

## 7. Definir email de contacto

- [x] 7.1 Decidir configuración de `privacy@arteriafit.com` (email definido, configuración futura si se requiere)
- [x] 7.2 Actualizar documentos legales con email definitivo
