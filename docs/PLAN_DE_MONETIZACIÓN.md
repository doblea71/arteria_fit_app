# PROMPT: Implementación de Monetización Ética e Híbrida para Arteria Fit (Flutter)

## Contexto del Proyecto

Arteria Fit es una app Flutter de bienestar cardiovascular. Toda la
lógica ya está implementada: ejercicios de respiración 4-7-8,
ejercicios isométricos, registro y protocolo de 7 días de presión
arterial, sección de nutrición y recetas. Los datos del usuario se
almacenan 100% localmente con SharedPreferences/SQLite.

La app NO tiene publicidad, NO bloquea funcionalidades y NO tiene
modelos de suscripción. La monetización debe ser completamente
voluntaria, transparente y éticamente coherente con una app de salud.

El sistema operativo objetivo principal es Android (Google Play).
iOS es secundario. La audiencia principal es España y Latinoamérica.

---

## OBJETIVO GENERAL

Implementar un sistema de monetización híbrido compuesto por:

1. **Tip Jar** (donaciones in-app como compras consumibles)
2. **Monetización pasiva P2B** mediante el SDK de Infatica
   (solo bajo consentimiento explícito del usuario)
3. **Centro de Consentimiento** (CMP) que cumpla con el RGPD
   y que bloquee la inicialización de cualquier SDK externo hasta
   obtener aprobación activa del usuario.

---

## MÓDULO 1: TIP JAR (Sistema de Donaciones In-App)

### Objetivo

Implementar compras in-app de tipo "consumible" usando el paquete
oficial `in_app_purchase` de Flutter. No usar RevenueCat ni Adapty
para este módulo (añaden overhead innecesario para un Tip Jar simple).

### Especificaciones técnicas

**1.1 Paquete a usar:**

```yaml
dependencies:
  in_app_purchase: ^3.2.0
```

**1.2 Productos a crear en Google Play Console y App Store Connect:**
Crear tres SKUs de tipo consumible (non-subscription, consumable):

- `tip_small`  → importe equivalente a ~1.99 EUR
- `tip_medium` → importe equivalente a ~4.99 EUR  
- `tip_large`  → importe equivalente a ~9.99 EUR

Nota: Los precios exactos los gestiona la tienda según la región.
Definir el precio base en USD y dejar que las stores apliquen
la conversión regional.

**1.3 Servicio a implementar: `TipJarService`**

Crear el archivo `lib/services/tip_jar_service.dart` con las
siguientes responsabilidades:

- Inicialización de la conexión con la store al arrancar la app
- Método `loadProducts()` que recupera los tres productos de la
  store (manejar el caso donde la store no devuelva productos)
- Método `purchaseTip(ProductDetails product)` que inicia la compra
- Stream listener del tipo `InAppPurchase.instance.purchaseStream`
  que gestione los estados: `pending`, `purchased`, `error`, `restored`
- Para compras de tipo consumible, llamar siempre a
  `InAppPurchase.instance.completePurchase(purchase)` una vez
  verificado el estado `purchased` para evitar que la compra
  quede pendiente
- Manejo de errores específicos: sin conexión a internet,
  cuenta de Google/Apple sin método de pago, producto no disponible
  en la región

**1.4 Widget de interfaz: `TipJarSheet`**

Crear un BottomSheet modal con las siguientes características:

- Título: "Apoya a Arteria Fit ❤️"
- Subtítulo: "Esta app es y será siempre gratuita. Si te ha
  ayudado con tu salud cardiovascular, considera apoyar su
  desarrollo con una pequeña contribución."
- Tres botones de donación, uno por SKU, mostrando el precio
  devuelto por la store (no hardcodeado), con etiquetas del tipo:
  "Café ☕ · 1,99€", "Almuerzo 🥗 · 4,99€", "Mes de trabajo 💪 · 9,99€"
- Estado de carga con shimmer mientras se recuperan los productos
- Estado de error con mensaje amigable si la store no responde
- Animación de agradecimiento tras una compra exitosa (Lottie o
  AnimatedContainer con ConfettiWidget)
- El sheet debe ser DismissKeyboard-safe y respetar el SafeArea

**1.5 Cuándo y cómo mostrar el `Tip Jar`**

NO mostrar en el onboarding ni en la pantalla de inicio.

Mostrar el Tip Jar únicamente en estos momentos (Aha Moments):

a) Cuando el usuario finaliza su primer Protocolo de 7 Días completo.
   Mostrar después de ver los resultados finales, con un delay de
   2 segundos para que el usuario asimile sus datos primero.

b) Cuando el usuario lleva más de 20 registros de presión arterial
   en el historial individual. Comprobar este umbral cada vez que
   se guarda una nueva medición.

c) Opción siempre accesible desde: Menú/Ajustes → "Apoya al
   desarrollador".

Implementar un sistema de control en SharedPreferences con la
clave `tip_jar_shown_count` (int) para no mostrar el Tip Jar
automático más de 2 veces en total. Si ya se mostró 2 veces, solo
mantener el acceso manual desde Ajustes.

---

## MÓDULO 2: MONETIZACIÓN PASIVA P2B (SDK Infatica)

### Objetivo

Integrar el SDK nativo de Infatica para Android e iOS mediante
MethodChannel. Esta funcionalidad es completamente opt-in y el
usuario debe activarla manualmente y conscientemente.

**CONDICIÓN CRÍTICA:** El SDK de Infatica NO debe inicializarse
bajo ninguna circunstancia antes de que:

1. El usuario haya completado el flujo de consentimiento (Módulo 3)
2. El usuario haya activado explícitamente el toggle de
   "Apoyar al desarrollador"

### Especificaciones técnicas

**2.1 MethodChannel a crear:**
Nombre del canal: com.arteriafit.app/passive_monetization

**2.2 Métodos del canal:**

- `initialize` → Inicializa el SDK de Infatica con el API key
  correspondiente (Android/iOS por separado)
- `start` → Activa el SDK (solo si hay Wi-Fi activo)
- `stop` → Detiene el SDK completamente
- `getStatus` → Devuelve el estado actual: `running`, `stopped`,
  `no_wifi`, `not_initialized`

**2.3 Implementación Android (MainActivity.kt o clase dedicada)**

```kotlin
// Crear PassiveMonetizationChannel.kt en el paquete nativo
// Responsabilidades:
// - Registrar el MethodChannel con el nombre definido
// - Verificar conectividad Wi-Fi antes de inicializar/arrancar
//   usando ConnectivityManager (API 23+)
// - Inicializar el SDK de Infatica en un hilo background 
//   (Coroutine Dispatchers.IO), NUNCA en el hilo principal
// - Registrar un BroadcastReceiver para cambios de conectividad
//   que detenga el SDK si se pierde el Wi-Fi
// - Detener el SDK cuando la app pase a background si la 
//   batería está por debajo del 20% (BatteryManager)
// - Manejar y propagar errores al lado Dart via Result.error()
```

**2.4 Implementación iOS (AppDelegate.swift o archivo dedicado)**

```swift
// Crear PassiveMonetizationChannel.swift
// Responsabilidades equivalentes a Android:
// - MethodChannel con el mismo nombre
// - Verificar Wi-Fi usando NWPathMonitor antes de activar
// - Inicializar en DispatchQueue.global(qos: .background)
// - Observer de UIApplication.didEnterBackgroundNotification
//   para revisar estado de batería y detener si < 20%
// - Manejar errores propagándolos como FlutterError
```

**2.5 Servicio Flutter: `PassiveMonetizationService`**

Crear `lib/services/passive_monetization_service.dart`:

- Singleton con método `initialize()` que solo ejecuta si el
  consentimiento fue dado (leer de SharedPreferences, clave:
  `passive_monetization_consent_given`, tipo bool)
- Método `enable()` que llama a `initialize` + `start` en la
  capa nativa
- Método `disable()` que llama a `stop` en la capa nativa
- Escuchar cambios de conectividad desde el lado Dart como
  capa adicional usando el paquete `connectivity_plus`
- Persistir la preferencia del usuario con clave
  `passive_monetization_enabled` en SharedPreferences

**2.6 Widget de control: `PassiveSupportToggle`**

Crear un widget tipo Card para la pantalla de Ajustes con:

- Título: "Apoya al desarrollador gratis"
- Subtítulo: "Cuando estés conectado a Wi-Fi, la app puede usar
  una pequeña fracción de tu conexión para tareas empresariales
  anónimas (verificación de anuncios, investigación de mercados).
  Tu información de salud nunca se comparte. Más info en nuestra
  Política de Privacidad."
- Switch/Toggle que persiste la preferencia
- Indicador de estado: "Activo · Wi-Fi conectado" / "Inactivo" /
  "Sin Wi-Fi"
- El toggle solo debe ser visible si el usuario completó el flujo
  de consentimiento (Módulo 3). Si no, mostrar un mensaje que
  dirija al onboarding de privacidad.

---

## MÓDULO 3: CENTRO DE CONSENTIMIENTO (CMP)

### Objetivo

Implementar un flujo de onboarding de privacidad que cumpla con
el RGPD (Reglamento UE 2016/679) y que gestione el consentimiento
para los SDKs de terceros. Dado que Arteria Fit es una app de salud,
aplicar los máximos estándares aunque los SDKs no procesen datos
de salud directamente.

### Especificaciones técnicas

**3.1 Control de flujo principal**

En `main.dart`, antes de mostrar cualquier pantalla funcional,
verificar la clave `onboarding_privacy_completed` en SharedPreferences:

- Si es `false` o no existe → mostrar `PrivacyOnboardingScreen`
- Si es `true` → continuar al flujo normal de la app

**3.2 Pantalla: `PrivacyOnboardingScreen`**

Esta pantalla es un PageView de 3 páginas (no se puede saltar):

**Página 1 — Bienvenida y Transparencia**

- Título: "Tu privacidad, primero"
- Texto: Explicar que la app almacena todos los datos de salud
  LOCALMENTE en el dispositivo y que nunca se sincronizan con
  servidores externos.
- Icono: escudo o candado

**Página 2 — Opciones de Apoyo al Desarrollador**
Presentar DOS opciones claramente diferenciadas con checkboxes
independientes (ninguno pre-marcado, RGPD Art. 7):

  ☐ **Donaciones in-app opcionales**  
  "Podrás realizar pequeñas donaciones voluntarias para apoyar
  el desarrollo de la app. No es obligatorio. Los pagos se
  procesan a través de Google Play / App Store de forma segura."

  ☐ **Red de apoyo anónimo (P2B)**  
  "Cuando estés en Wi-Fi, la app puede usar una fracción mínima
  de tu conexión para tareas empresariales anónimas. Esto no
  incluye ni accede a tus datos de salud. Puedes desactivarlo
  en cualquier momento desde Ajustes."

- Enlace visible a Política de Privacidad completa (abrir en
  WebView o navegador externo)
- Enlace visible a Términos de Uso

**Página 3 — Confirmación**

- Resumen visual de lo que el usuario ha elegido
- Botón principal: "Entendido, comenzar" (siempre habilitado,
  incluso si ambas opciones están desmarcadas)
- Texto pequeño: "Puedes cambiar estas preferencias en cualquier
  momento desde Ajustes → Privacidad"

**3.3 Al confirmar el onboarding:**

- Guardar `onboarding_privacy_completed` = true
- Guardar `tip_jar_consent` = [valor del checkbox 1] (bool)
- Guardar `passive_monetization_consent_given` = [valor checkbox 2]
  (bool)
- Si `passive_monetization_consent_given` es true, llamar a
  `PassiveMonetizationService.initialize()` pero NO a `.enable()`
  aún (eso lo hace el usuario desde el toggle en Ajustes)
- Si `passive_monetization_consent_given` es false, nunca llamar
  al SDK de Infatica, ni en init, ni en background

**3.4 Pantalla de Privacidad en Ajustes**

Crear una sección "Privacidad y Apoyo" en la pantalla de Ajustes
existente con:

- Resumen de consentimientos dados
- Botón "Revisar mis preferencias de privacidad" que vuelve a
  mostrar la página 2 del onboarding para modificar preferencias
- Toggle del Módulo 2 (`PassiveSupportToggle`)
- Acceso al Tip Jar (Módulo 1)
- Acceso a Política de Privacidad y Términos de Uso
- Sección "Mis datos": botón "Eliminar todos mis datos" que
  borra SharedPreferences y base de datos local (cumplimiento
  RGPD Art. 17 - Derecho al olvido)

---

## MÓDULO 4: OPTIMIZACIÓN Y CONSIDERACIONES TRANSVERSALES

**4.1 Rendimiento**

- Todos los MethodChannel calls del SDK de Infatica deben ejecutarse
  en hilos background tanto en Dart como en la capa nativa
- El TipJarService debe inicializar su conexión con la store de
  forma lazy (no en el arranque de la app, sino cuando el usuario
  navegue a una pantalla que pueda mostrar el Tip Jar)
- Implementar timeout de 10 segundos en las llamadas a las stores
  para evitar que la UI quede bloqueada esperando

**4.2 Manejo de estados y errores**

- Usar el patrón Result<T> o similar para propagar errores de
  forma limpia desde los servicios a los widgets
- En el TipJarService, distinguir entre: error de red, error de
  store, producto no disponible en región, usuario sin método
  de pago configurado
- Nunca mostrar errores técnicos al usuario. Mapear cada error
  a un mensaje amigable en español

**4.3 Testing**

- Para probar el Tip Jar en Android: usar las cuentas de prueba
  de Google Play definidas en Play Console. Los emuladores no
  soportan compras reales.
- Para probar en iOS: configurar un entorno Sandbox en App Store
  Connect con un Apple ID de prueba
- Para el SDK de Infatica: implementar un modo mock en
  DEBUG (`kDebugMode`) que simule las respuestas del MethodChannel
  sin inicializar el SDK real

**4.4 Estructura de archivos propuesta**
lib/
services/
tip_jar_service.dart
passive_monetization_service.dart
consent_manager.dart          ← Fuente única de verdad para consentimientos
screens/
onboarding/
privacy_onboarding_screen.dart
settings/
privacy_settings_screen.dart
widgets/
tip_jar_sheet.dart
passive_support_toggle.dart
android/app/src/main/kotlin/.../
PassiveMonetizationChannel.kt
ios/Runner/
PassiveMonetizationChannel.swift

**4.5 Dependencias a añadir al pubspec.yaml**

```yaml
dependencies:
  in_app_purchase: ^3.2.0
  shared_preferences: ^2.3.0    # probablemente ya existe
  connectivity_plus: ^6.0.0
  lottie: ^3.1.0                 # para animación de agradecimiento en Tip Jar

dev_dependencies:
  # sin cambios específicos para este módulo
```

---

## NOTAS FINALES PARA EL AGENTE

1. La política de privacidad y los términos de uso deben ser
   documentos reales alojados en una URL pública (GitHub Pages
   o similar). El agente debe crear templates de estos documentos
   en Markdown adaptados a Arteria Fit, mencionando explícitamente
   el uso del SDK de Infatica y el sistema de donaciones in-app.

2. En Google Play Console, al publicar la nueva versión, será
   necesario actualizar el cuestionario de seguridad de datos
   (Data Safety) para reflejar el uso de Infatica. El agente
   debe proporcionar las respuestas correctas al cuestionario
   según la documentación de Infatica.

3. Si el SDK de Infatica no tiene paquete pub.dev actualizado
   para la versión actual de Flutter, priorizar la integración
   mediante MethodChannel como se describe. No usar wrappers
   no oficiales de terceros.

4. El diseño visual de todos los widgets debe seguir el sistema
   de diseño existente de Arteria Fit (tema premium, soporte
   light/dark mode, micro-animaciones usando el MCP de Stitch)
   para que la monetización sea percibida como parte natural de
   la app y no como un elemento añadido externamente.
