# Análisis de Viabilidad: Plan de Monetización Híbrida

**Fecha de análisis:** 2026-03-23
**Proyecto:** Arteria Fit v1.8.5+23
**Documento de referencia:** PLAN_DE_MONETIZACIÓN.md

---

## Resumen Ejecutivo

El plan de monetización propuesto es **viable técnicamente** pero presenta **desafíos significativos** que deben abordarse antes de la implementación. Se recomienda implementar los módulos en orden (1 → 3 → 2) debido a las dependencias entre ellos.

### Veredicto por Módulo

| Módulo | Viabilidad | Complejidad | Tiempo Estimado |
|--------|------------|-------------|-----------------|
| **Módulo 1: Tip Jar** | ✅ Alta | Media | 8-12 horas |
| **Módulo 2: Infatica SDK** | ⚠️ Media | Alta | 16-24 horas |
| **Módulo 3: CMP/Consentimiento** | ✅ Alta | Media | 6-10 horas |

---

## Análisis Detallado por Módulo

---

## MÓDULO 1: Tip Jar (Donaciones In-App)

### Estado Actual del Proyecto

**Dependencias existentes:**
- `shared_preferences: ^2.2.2` ✅ (ya instalado, compatible con versión propuesta ^2.3.0)
- Arquitectura Riverpod ya implementada
- Sistema de navegación GoRouter funcional

**Dependencias requeridas (nuevas):**
- `in_app_purchase: ^3.2.0`
- `lottie: ^3.1.0`

### Viabilidad Técnica: ✅ ALTA

#### Puntos a Favor

1. **Integración directa con Flutter:** El paquete `in_app_purchase` es oficial de Flutter y está bien documentado.

2. **Patrones ya existentes:**
   - El proyecto ya usa SharedPreferences para persistencia
   - Ya existe un patrón de servicio (`DatabaseService`, `NotificationService`)
   - La pantalla de Settings (`settings_screen.dart`) ya tiene estructura para añadir secciones

3. **Puntos de integración claros:**
   - `bp_session_screen.dart` → para mostrar Tip Jar al completar protocolo de 7 días
   - `bp_history_screen.dart` → para mostrar al alcanzar 20 registros
   - `settings_screen.dart` → acceso manual desde Ajustes

#### Desafíos Identificados

| Desafío | Impacto | Solución |
|---------|---------|----------|
| Configuración en Google Play Console | Medio | Requiere crear SKUs manualmente en la consola |
| Testing en emulador | Bajo | Usar dispositivo físico con cuenta de prueba |
| Manejo de errores de store | Medio | Implementar mapeo de códigos de error |
| Animación Lottie | Bajo | Alternativa: usar AnimatedContainer + ConfettiWidget |

#### Implementación Recomendada

```
lib/
├── core/
│   └── services/
│       └── tip_jar_service.dart    ← Nuevo
├── features/
│   └── settings/
│       └── settings_screen.dart    ← Modificar (añadir sección)
├── widgets/
│   └── tip_jar_sheet.dart          ← Nuevo
```

#### Código Clave Necesario

**SharedPreferences para control de visualizaciones:**
- `tip_jar_shown_count` (int) - Contador de visualizaciones automáticas
- `tip_jar_consent` (bool) - Consentimiento del onboarding

### Prerrequisitos Antes de Implementar

1. **En Google Play Console:**
   - Crear 3 productos consumibles: `tip_small`, `tip_medium`, `tip_large`
   - Configurar precios por región (base USD, conversión automática)

2. **En App Store Connect (si se publica en iOS):**
   - Crear los mismos 3 productos consumibles
   - Configurar precios

3. **Testing:**
   - Configurar cuentas de prueba en Play Console
   - Probar flujo completo de compra y consumo

---

## MÓDULO 2: Monetización Pasiva P2B (SDK Infatica)

### Viabilidad Técnica: ⚠️ MEDIA

#### Puntos a Favor

1. **MethodChannel es patrón estándar** en Flutter para código nativo
2. **MainActivity.kt actual es minimalista**, fácil de extender
3. **AppDelegate.swift también es simple**, sin configuración compleja

#### Desafíos Significativos

| Desafío | Impacto | Descripción |
|---------|---------|-------------|
| **SDK de Infatica** | ⚠️ Alto | No existe paquete pub.dev oficial. Requiere integración nativa manual. |
| **Verificación de Wi-Fi** | Medio | Implementación diferente en Android (ConnectivityManager) vs iOS (NWPathMonitor) |
| **Gestión de batería** | Medio | Requiere permisos adicionales y lógica específica por plataforma |
| **Testing** | Alto | Difícil de probar sin dispositivos reales en diversas condiciones |

#### Análisis del SDK de Infatica

**Problema Crítico:** El documento menciona "el SDK de Infatica" pero:

1. No proporciona documentación específica del SDK
2. No indica versión del SDK a usar
3. No especifica cómo obtener las API keys
4. No detalla las capacidades reales del SDK

**Recomendación:** Antes de implementar este módulo, se debe:

1. Verificar disponibilidad del SDK de Infatica para Android/iOS
2. Obtener documentación oficial del SDK
3. Confirmar proceso de registro y obtención de API keys
4. Validar términos de servicio y cumplimiento RGPD

#### Implementación Nativa Requerida

**Android (PassiveMonetizationChannel.kt):**
```kotlin
// Estructura aproximada
class PassiveMonetizationChannel(
    private val context: Context,
    private val messenger: BinaryMessenger
) : MethodChannel.MethodCallHandler {

    // Requiere:
    // - Permiso ACCESS_NETWORK_STATE
    // - Permiso ACCESS_WIFI_STATE
    // - Permiso BATTERY_STATS (para lectura de batería)
    // - BroadcastReceiver para cambios de conectividad
}
```

**iOS (PassiveMonetizationChannel.swift):**
```swift
// Estructura aproximada
class PassiveMonetizationChannel: NSObject, FlutterPlugin {

    // Requiere:
    // - NWPathMonitor para conectividad
    // - UIDevice.current.batteryLevel para batería
    // - Background modes apropiados
}
```

#### Dependencias Adicionales

```yaml
dependencies:
  connectivity_plus: ^6.0.0  # Para verificación desde Flutter
```

### Prerrequisitos Antes de Implementar

1. **Investigación del SDK:**
   - Confirmar que Infatica ofrece SDK móvil (no solo proxy SDK)
   - Obtener documentación actualizada
   - Verificar compatibilidad con Flutter

2. **Configuración legal:**
   - Revisar términos de servicio de Infatica
   - Confirmar cumplimiento RGPD
   - Preparar documentación de privacidad

3. **Permisos Android (AndroidManifest.xml):**
   ```xml
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
   ```

4. **Permisos iOS (Info.plist):**
   - Posiblemente requerir configuración de background modes

---

## MÓDULO 3: Centro de Consentimiento (CMP)

### Viabilidad Técnica: ✅ ALTA

#### Puntos a Favor

1. **100% implementable en Flutter** - No requiere código nativo
2. **SharedPreferences ya en uso** - Mismo patrón de almacenamiento
3. **UI consistente con el tema existente** - El proyecto tiene AppTheme definido
4. **Patrón PageView familiar** - Similar a onboardings típicos

#### Puntos de Integración

```
lib/
├── main.dart                              ← Modificar (verificar onboarding)
├── core/
│   └── services/
│       └── consent_manager.dart           ← Nuevo
├── screens/
│   └── onboarding/
│       └── privacy_onboarding_screen.dart ← Nuevo
├── features/
│   └── settings/
│       └── settings_screen.dart           ← Modificar (sección privacidad)
```

#### Flujo de Inicialización Propuesto

```dart
// En main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  // Verificar onboarding de privacidad ANTES de inicializar nada
  final consentManager = ConsentManager();
  final hasConsent = await consentManager.hasCompletedOnboarding();

  if (hasConsent) {
    await NotificationService().init();
    // Otros servicios...
  }

  runApp(ProviderScope(child: ArteriaFitApp()));
}
```

#### SharedPreferences a Gestionar

| Clave | Tipo | Descripción |
|-------|------|-------------|
| `onboarding_privacy_completed` | bool | ¿Completó el onboarding? |
| `tip_jar_consent` | bool | ¿Aceptó donaciones in-app? |
| `passive_monetization_consent_given` | bool | ¿Aceptó monetización pasiva? |
| `passive_monetization_enabled` | bool | ¿Tiene activo el toggle? |

#### Cumplimiento RGPD Verificado

El diseño propuesto cumple con:
- ✅ Art. 7 RGPD (consentimiento libre, específico e informado)
- ✅ Art. 17 RGPD (derecho al olvido - botón "Eliminar todos mis datos")
- ✅ Art. 7(3) RGPD (consentimiento revocable - toggle para desactivar)
- ✅ Art. 13 RGPD (información clara sobre tratamiento de datos)

### Prerrequisitos Antes de Implementar

1. **Documentos legales:**
   - Crear Política de Privacidad (URL pública)
   - Crear Términos de Uso (URL pública)
   - Alojar en GitHub Pages o similar

2. **Contenido del onboarding:**
   - Redactar textos legales en español
   - Adaptar para España/Latinoamérica

---

## Análisis de Riesgos

### Riesgos Técnicos

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| SDK Infatica no disponible para móvil | Media | Alto | Investigar antes de implementar |
| Rechazo de Apple por IAP | Baja | Alto | Tip Jar usa IAP oficial, no debería haber problema |
| Errores en compras no consumidas | Media | Medio | Implementar `completePurchase` correctamente |
| Pérdida de datos de preferencias | Baja | Bajo | SharedPreferences es persistente |

### Riesgos Legales/Comerciales

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Revisión RGPD por autoridades | Baja | Alto | Documentación legal completa |
| Rechazo en Google Play por Data Safety | Media | Alto | Actualizar cuestionario correctamente |
| Usuarios reportando uso de batería/red | Media | Medio | Implementar restricciones de batería/Wi-Fi |

---

## Orden de Implementación Recomendado

### Fase 1: Módulo 3 (CMP) - Primero
**Razón:** Es prerequisito para el Módulo 2 y no depende de nada externo.

**Duración:** 6-10 horas

**Entregables:**
1. `ConsentManager` service
2. `PrivacyOnboardingScreen` (PageView de 3 páginas)
3. Sección "Privacidad y Apoyo" en Settings
4. Función "Eliminar todos mis datos"

### Fase 2: Módulo 1 (Tip Jar) - Segundo
**Razón:** Más rápido de implementar, genera ingresos desde el día 1.

**Duración:** 8-12 horas

**Entregables:**
1. `TipJarService`
2. `TipJarSheet` widget
3. Integración en puntos de "Aha Moments"
4. SKUs configurados en tiendas

### Fase 3: Módulo 2 (Infatica) - Tercero
**Razón:** Más complejo, requiere investigación previa del SDK.

**Duración:** 16-24 horas (dependiendo de disponibilidad del SDK)

**Entregables:**
1. Código nativo Android (PassiveMonetizationChannel.kt)
2. Código nativo iOS (PassiveMonetizationChannel.swift)
3. `PassiveMonetizationService` Flutter
4. `PassiveSupportToggle` widget
5. Testing en múltiples dispositivos

---

## Documentos Legales Necesarios

### Política de Privacidad (Template)

El documento debe incluir:

1. **Identidad del responsable:** Nombre del desarrollador
2. **Datos tratados:** Lista de datos almacenados localmente
3. **SDKs de terceros:** Infatica (si aplica)
4. **Derechos del usuario:** Acceso, rectificación, supresión
5. **Contacto:** Email para solicitudes RGPD

### Términos de Uso (Template)

1. **Objeto:** Uso de la app de salud cardiovascular
2. **Exención de responsabilidad:** No sustituye consejo médico
3. **Licencia de uso:** Gratuita, sin garantías
4. **Modificaciones:** Derecho a cambiar términos

---

## Actualizaciones Requeridas en Google Play Console

### Data Safety Section

Al implementar monetización, actualizar:

1. **Datos personales:**
   - ¿La app recopila datos personales? → No (todo es local)

2. **Datos financieros:**
   - ¿Procesa pagos? → Sí, a través de Google Play Billing

3. **SDKs de terceros:**
   - Si se usa Infatica, declarar:
     - Tipo de datos compartidos
     - Propósito (verificación de anuncios, investigación de mercados)
     - ¿Los datos se encriptan en tránsito?

---

## Conclusión

### Implementación Recomendada

**Sí es viable**, pero se recomienda:

1. ✅ **Implementar Módulo 3 (CMP) primero** - Sin dependencias externas
2. ✅ **Implementar Módulo 1 (Tip Jar) segundo** - Ingresos inmediatos
3. ⚠️ **Investigar Módulo 2 (Infatica) antes de implementar** - Confirmar disponibilidad del SDK

### Alternativa al Módulo 2

Si el SDK de Infatica no está disponible o tiene limitaciones significativas, considerar:

1. **SDK alternativo:** Investigar otros proveedores P2B (Honeygain SDK, etc.)
2. **Solo Tip Jar:** Implementar solo donaciones y posicionar la app como "apoyada por la comunidad"
3. **Suscripción Premium:** Añadir funcionalidades premium opcionales (estadísticas avanzadas, exportación PDF, etc.)

---

## Checklist Pre-Implementación

- [ ] Verificar disponibilidad del SDK Infatica
- [ ] Obtener API keys de Infatica (si aplica)
- [ ] Crear Política de Privacidad y alojarla
- [ ] Crear Términos de Uso y alojarlos
- [ ] Crear SKUs en Google Play Console
- [ ] Configurar cuenta de prueba en Play Console
- [ ] Revisar términos de servicio de Infatica
- [ ] Actualizar Data Safety en Play Console
- [ ] Preparar textos legales en español
- [ ] Definir textos de UI del onboarding

---

## Estimación de Esfuerzo Total

| Módulo | Horas Estimadas | Prioridad |
|--------|----------------|-----------|
| Módulo 3 (CMP) | 6-10 h | Alta |
| Módulo 1 (Tip Jar) | 8-12 h | Alta |
| Módulo 2 (Infatica) | 16-24 h | Media |
| Documentación legal | 4-6 h | Alta |
| Testing y QA | 6-8 h | Alta |
| **Total** | **40-60 h** | - |

---

**Documento generado automáticamente como análisis de viabilidad del PLAN_DE_MONETIZACIÓN.md**