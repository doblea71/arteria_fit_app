## Context

Arteria Fit se distribuye vía GitHub Release sin cuenta de desarrollador en Google Play o Apple Store. Para monetizar sin comisiones de tiendas, se implementa un sistema de donaciones vía enlaces externos.

**Restricciones:**
- Sin IAP (In-App Purchases)
- Sin cuenta de desarrollador en tiendas
- Distribución vía GitHub Release
- 100% Flutter

**Plataformas de donación:**
- Ko-fi (principal, 0% comisiones)
- PayPal.me (alternativa)
- GitHub Sponsors (opcional)

## Goals / Non-Goals

**Goals:**
- Monetización sin comisiones de tiendas
- Experiencia de usuario no intrusiva
- Rate limiting para evitar spam de sugerencias
- Respetar consentimiento del usuario (RGPD)

**Non-Goals:**
- Integración real con pasarelas de pago
- Verificación de donaciones reales
- Auto-reporte de transacciones verificado

## Decisions

### DEC-1: Bottom Sheet sobre Dialog

**Decisión:** Usar showModalBottomSheet para mostrar opciones de donación

**Alternativas:**
- Dialog: Más intrusivo, interrumpe flujo
- Pantalla completa: Navegación compleja

**Rationale:** Bottom sheet es menos intrusivo, estándar en apps móviles, fácil de descartar.

### DEC-2: SharedPreferences para persistencia

**Decisión:** Usar SharedPreferences para tracking de prompts

**Alternativas:**
- SQLite: Overkill para 4-5 valores
- API externa: Complejidad innecesaria

**Rationale:** SharedPreferences es suficiente para booleanos, ints y strings. Integración nativa.

### DEC-3: Rate limiting de 30 días

**Decisión:** No mostrar sugerencia si han pasado menos de 30 días

**Rationale:** Balance entre no spamear al usuario y mantener visibilidad del proyecto.

### DEC-4: Aha Moments estratégicos

**Decisión:** Mostrar sugerencia en momentos de "victoria" del usuario

**Triggers:**
- Completar sesión #7 de protocolo BP (logro)
- Ver historial con 20+ registros (compromiso)
- Settings (acceso manual)

**Rationale:** El usuario está más receptivo cuando ve valor en la app.

### DEC-5: Auto-reporte de donación

**Decisión:** Permitir al usuario marcar "Ya doné" sin verificación

**Rationale:** Sin integración con pasarela, no hay forma de verificar. Badge es cosmético pero motiva.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Usuario no reporta donación | Badge solo aparece si usuario lo marca manualmente |
| Plataformas externas no disponibles | URLs hardcodeadas, usuario puede ir directamente |
| Sugerencias muy frecuentes | Rate limiting de 30 días obligatorio |
| No genera suficiente revenue | Es resultado esperado - donations son opt-in |
