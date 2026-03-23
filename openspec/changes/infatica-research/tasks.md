## 1. Fase 1: Investigación Infatica

- [x] 1.1 Buscar "Infatica SDK mobile" en web
- [x] 1.2 Visitar sitio oficial de Infatica
- [x] 1.3 Verificar si ofrecen SDK móvil ✅ (Android, iOS, Windows, macOS)
- [x] 1.4 Verificar documentación técnica disponible ⚠️ (requiere partnership)
- [x] 1.5 Investigar proceso de registro y API keys ⚠️ (lento, requiere contactar equipo)
- [x] 1.6 Analizar modelo de ingresos ✅ (P2B)
- [x] 1.7 Verificar cumplimiento RGPD ✅ (certificaciones ISO)
- [x] 1.8 Documentar hallazgos de Infatica ❌ (No viable - proceso lento)

## 2. Fase 1: Evaluar Alternativas

- [x] 2.1 Investigar Honeygain SDK ✅ **VIABLE**
- [ ] 2.2 Investigar PacketStream (pendiente - no prioritario)
- [ ] 2.3 Investigar TraffMonetizer (pendiente - no prioritario)
- [x] 2.4 Comparar alternativas ✅
- [x] 2.5 Documentar pros/contras de cada alternativa ✅

## 3. Fase 1: Documento de Decisión

- [x] 3.1 Crear `docs/DECISION_MONETIZACION_PASIVA.md` ✅
- [x] 3.2 Documentar investigación realizada ✅
- [x] 3.3 Documentar opciones evaluadas ✅ (Infatica ❌, Honeygain ✅)
- [x] 3.4 Definir criterios de evaluación ✅
- [x] 3.5 Tomar decisión: IMPLEMENTAR ✅ **HONEYGAIN SDK**
- [x] 3.6 Documentar justificación ✅

## 4. Fase 2: Implementación (DECISIÓN: HONEYGAIN SDK)

### Pasos Previos
- [ ] 4.0.1 Registrar cuenta en https://sdk.honeygain.com/dashboard/register
- [ ] 4.0.2 Obtener API keys
- [ ] 4.0.3 Revisar documentación en https://developers.honeygain.com/docs/

### 4.1 Integrar SDK
- [ ] 4.1.1 Añadir dependencia SDK en pubspec.yaml (verificar si existe paquete Flutter)
- [ ] 4.1.2 Configurar API keys
- [ ] 4.1.3 Implementar MethodChannel si requiere código nativo
- [ ] 4.1.4 Implementar inicialización

### 4.2 PassiveMonetizationService
- [ ] 4.2.1 Crear `lib/core/services/passive_monetization_service.dart`
- [ ] 4.2.2 Implementar `initialize(apiKey)`
- [ ] 4.2.3 Implementar `isActive()`
- [ ] 4.2.4 Implementar `enable()` / `disable()`
- [ ] 4.2.5 Implementar `canRunSafely()`
- [ ] 4.2.6 Implementar `getStats()`

### 4.3 PassiveSupportToggle Widget
- [ ] 4.3.1 Crear `lib/widgets/passive_support_toggle.dart`
- [ ] 4.3.2 Implementar toggle UI
- [ ] 4.3.3 Mostrar estadísticas
- [ ] 4.3.4 Respetar consentimiento (passive_monetization_consent)

### 4.4 Restricciones
- [ ] 4.4.1 Implementar verificación Wi-Fi
- [ ] 4.4.2 Implementar verificación batería > 50%
- [ ] 4.4.3 Mostrar estado de restricciones

### 4.5 Actualizar Documentos Legales
- [ ] 4.5.1 Actualizar `docs/privacy-policy.html`
- [ ] 4.5.2 Añadir sección monetización pasiva Honeygain

### 4.6 Integración en Settings
- [ ] 4.6.1 Modificar `lib/features/settings/settings_screen.dart`
- [ ] 4.6.2 Añadir sección "Apoyo pasivo"

## 5. Testing & Verificación

- [ ] 5.1 Run `flutter analyze`
- [ ] 5.2 Test SDK initialization
- [ ] 5.3 Test toggle enable/disable
- [ ] 5.4 Test Wi-Fi restriction
- [ ] 5.5 Test battery restriction
- [ ] 5.6 Test consent respect
- [ ] 5.7 Test Light/Dark theme
