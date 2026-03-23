## Context

El Centro de Consentimiento (CMP) es el primer módulo de monetización requerido para Arteria Fit. Debe implementarse antes de SPEC-017 (donaciones) y SPEC-018 (Infatica).

La app actualmente no tiene ningún flujo de onboarding ni gestión de consentimiento. Todos los datos se almacenan localmente sin información RGPD visible al usuario.

**Restricciones técnicas:**
- 100% Flutter (sin código nativo)
- SharedPreferences para persistencia de consentimientos
- Dependiente de SPEC-015 para URLs legales

## Goals / Non-Goals

**Goals:**
- Cumplimiento RGPD (Art. 7, 13, 17, 20)
- Onboarding de privacidad claro y conciso
- Consentimiento granular (tip jar vs monetización pasiva)
- Derecho al olvido (eliminación completa)
- Derecho a portabilidad (export JSON)

**Non-Goals:**
- Sistema de login/usuario (datos 100% locales)
- Monetización real (solo estructura de consentimiento)
- Analytics o tracking de usuarios

## Decisions

### DEC-1: SharedPreferences sobre SQLite para consentimientos

**Decisión:** Usar SharedPreferences para almacenar preferencias de consentimiento

**Alternativas:**
- SQLite: Overkill para 5-6 valores booleanos
- Hive/Isar: Añade dependencia adicional innecesaria

**Rationale:** SharedPreferences es suficiente para booleanos y strings simples. Integración nativa con Flutter.

### DEC-2: PageView para onboarding

**Decisión:** Usar PageView con PageController para las 3 páginas del onboarding

**Alternativas:**
- Navigator.pushReplacement: Más complejo de gestionar estado
- GoRouter con redirect: Funciona pero overkill para onboarding simple

**Rationale:** PageView es el patrón Flutter estándar para onboarding. Fácil de implementar con indicadores de progreso.

### DEC-3: Doble confirmación para eliminación

**Decisión:** Dos diálogos de confirmación + input de texto "ELIMINAR"

**Alternativas:**
- Un solo diálogo: Menos seguro contra accidentes
- Biométrico: Excesivo para este caso de uso

**Rationale:** La acción es destructiva e irreversible. Doble confirmación con texto reduce riesgos.

### DEC-4: JSON para exportación de datos

**Decisión:** Exportar todos los datos como archivo JSON

**Alternativas:**
- CSV: Limitado para datos jerárquicos
- PDF: Más complejo de generar

**Rationale:** JSON es estándar, legible, y cubre todos los tipos de datos de la app.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Onboarding muy largo = usuario abandona | 3 páginas concisas, skip parcial permitido |
| SharedPreferences corrupto | try-catch en cada operación, fallback a defaults |
| Eliminación parcial de datos | Limpiar SharedPreferences + DB + documentos directory |
| Export falla en dispositivos sin storage | Usar share_plus para compartir archivo |
