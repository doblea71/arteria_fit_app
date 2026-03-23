## Context

La app Arteria Fit se distribuye vía GitHub Release sin cuenta de Google Play ni Apple Store. Para implementar funcionalidades de monetización (donaciones) y cumplir con RGPD, es necesario:

1. Documentos legales públicos accesibles via HTTPS
2. URLs knowable para la app Flutter
3. Infraestructura que no requiere mantenimiento continuo

**Desarrollador:** Angel Emiro Antunez Villasmil (DevDoblea)
**Repositorio:** `devdoblea/arteria_fit_app`

## Goals / Non-Goals

**Goals:**
- Configurar GitHub Pages con SSL automático (HTTPS)
- Publicar Política de Privacidad RGPD-compliant
- Publicar Términos de Uso
- Integrar URLs en Flutter via constantes
- Definir email de contacto RGPD funcional

**Non-Goals:**
- Sistema de email automatizado (solo dirección de contacto)
- Legal compliance más allá de documentos básicos
- Hosting fuera de GitHub

## Decisions

### DEC-1: GitHub Pages sobre hosting alternativo

**Decisión:** Usar GitHub Pages integrado en el repositorio

**Alternativas:**
- Netlify/Vercel: Más features, pero requiere cuenta adicional
- Cloudflare Pages: Similar a Netlify

**Rationale:** GitHub Pages es nativo al repositorio, SSL automático, sin costo, y suficiente para documentos estáticos. El desarrollador ya tiene cuenta GitHub.

### DEC-2: Rama `docs/` sobre rama `gh-pages` separada

**Decisión:** Usar directorio `docs/` en `main`

**Alternativas:**
- Rama `gh-pages`: Más complejo, requiere workflow de deploy

**Rationale:** GitHub puede servir desde `docs/` automáticamente habilitando Pages. Más simple de mantener.

### DEC-3: HTML estático con CSS básico

**Decisión:** Archivos HTML con CSS embebido inline

**Alternativas:**
- Jekyll/Hugo: Overkill para 2-3 páginas
- Framework JS: Excesivo para contenido estático

**Rationale:** HTML puro es simple, portable, y fácil de editar manualmente si es necesario.

### DEC-4: Email `privacy@arteriafit.com`

**Decisión:** Crear email dedicado para contacto RGPD

**Alternativas:**
- Email personal: Menor profesionalismo
- GitHub Discussions: No es email estándar RGPD

**Rationale:** Usar GitHub Pages + Cloudflare Workers (email forwarding gratuito) o simplemente definir el email y configurar después.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| GitHub Pages no disponible momentáneamente | Los documentos también estarán en el repo (backup) |
| Email no configurado inicialmente | Usar email personal como fallback temporal |
| Contenido legal no cover todas las jurisdicciones | Documentos en español para España, disclaimers claros |
