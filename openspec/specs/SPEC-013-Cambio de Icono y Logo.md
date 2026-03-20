# SPEC-013 — Ícono de App y Splash Screen Personalizado

## Status: Proposed

## Context

La app actualmente usa el ícono por defecto de Flutter (logo de Flutter)
tanto en el launcher del dispositivo como en la pantalla de inicio (Splash
Screen). Se requiere reemplazar ambos por assets personalizados alusivos
al propósito de la app (ejercicios de respiración y bienestar).
Si no existe una Splash Screen personalizada, se debe crear una.
Todo debe ser compatible con Android e iOS, en sus variantes de resolución
y modo Light/Dark.

## Requirements

### REQ-013-1 — Reemplazar el ícono del launcher en Android e iOS

El sistema DEBE mostrar el ícono personalizado de la app en el launcher
(pantalla de inicio del SO) tanto en Android como en iOS, reemplazando
el ícono por defecto de Flutter.
El ícono DEBE generarse en todas las resoluciones requeridas por cada
plataforma a partir de un único asset fuente de alta resolución.

### REQ-013-2 — Asset fuente del ícono

El ícono fuente DEBE ser un archivo PNG de mínimo 1024×1024 píxeles,
con fondo transparente o sólido según el diseño, ubicado en:
`assets/logo/arteria-fit.png`
El equipo de diseño (o el desarrollador) ha provisto este archivo y
otros archivos relacionados y se ubican dentro de la carpeta `assets/logo/`
dentro de carpetas con nombres como `android`, `ios`, `web`.

### REQ-013-3 — Ícono adaptativo en Android (Adaptive Icon)

En Android 8.0+ (API 26+), el ícono DEBE ser un Adaptive Icon con:

- Capa de primer plano (`foreground`): el logo/ícono de la app.
- Capa de fondo (`background`): color sólido o asset de fondo.
Esto garantiza compatibilidad con las distintas formas de ícono
que aplican los launchers de Android (círculo, squircle, cuadrado).

### REQ-013-4 — Soporte de modo Dark para el ícono (opcional, Android 13+)

Si el diseño lo permite, el sistema DEBERÍA proveer una variante del
ícono para modo Dark (monocromático) compatible con Android 13+
(Themed Icons). Este requisito es de segunda prioridad.

### REQ-013-5 — Detección y uso de Splash Screen existente

El sistema DEBE detectar si existe una Splash Screen personalizada:

- Si existe: actualizarla con el nuevo ícono/logo y los colores
  de la app, respetando la implementación actual.
- Si no existe o es la Splash Screen por defecto de Flutter:
  crear una Splash Screen personalizada según REQ-013-6.

### REQ-013-6 — Splash Screen personalizada

La Splash Screen DEBE mostrar:

- El ícono/logo de la app centrado vertical y horizontalmente.
- Un color de fondo consistente con el tema principal de la app.
- Opcionalmente: el nombre de la app debajo del ícono.
La Splash Screen NO DEBE mostrar el logo de Flutter ni ningún
asset por defecto del framework.

### REQ-013-7 — Splash Screen para modo Light y modo Dark

La Splash Screen DEBE tener variantes de color de fondo para
modo Light y modo Dark del sistema operativo, de forma que
el color de fondo de la Splash Screen sea siempre consistente
con el tema del SO en el momento de apertura de la app.

### REQ-013-8 — Duración de la Splash Screen

La Splash Screen DEBE mostrarse únicamente durante el tiempo
de inicialización nativa de la app (native splash). NO DEBE
implementarse un retardo artificial (sleep/delay) para prolongar
su duración. En cuanto Flutter esté listo, la Splash Screen
desaparece y aparece la primera pantalla de la app.

### REQ-013-9 — Compatibilidad con iOS

En iOS, el ícono DEBE generarse para todas las resoluciones
requeridas por el App Store y el sistema (20pt hasta 1024pt).
La Splash Screen en iOS DEBE implementarse mediante
`LaunchScreen.storyboard` o el método equivalente soportado
por el paquete elegido.

## Acceptance Criteria

- DADO QUE la app está instalada en un dispositivo Android,
  CUANDO el usuario visualiza el launcher,
  ENTONCES ve el ícono personalizado (no el logo de Flutter)
  en la forma que aplique el launcher del dispositivo.

- DADO QUE la app está instalada en un dispositivo iOS,
  CUANDO el usuario visualiza la pantalla de inicio,
  ENTONCES ve el ícono personalizado en la resolución correcta.

- DADO QUE el usuario abre la app desde el launcher,
  CUANDO la app se está inicializando,
  ENTONCES ve la Splash Screen personalizada con el ícono/logo
  centrado y el color de fondo correcto.

- DADO QUE el dispositivo tiene el modo Dark activo del SO,
  CUANDO se muestra la Splash Screen,
  ENTONCES el color de fondo es la variante Dark definida.

- DADO QUE el dispositivo tiene el modo Light activo del SO,
  CUANDO se muestra la Splash Screen,
  ENTONCES el color de fondo es la variante Light definida.

- DADO QUE la Splash Screen se muestra,
  CUANDO Flutter termina de inicializarse,
  ENTONCES la Splash Screen desaparece inmediatamente sin
  retardo artificial visible.

- DADO QUE se cambia el asset `app_icon.png` por uno nuevo
  y se re-ejecuta el generador de íconos,
  CUANDO se instala la nueva versión de la app,
  ENTONCES todos los íconos y la Splash Screen reflejan
  el nuevo asset sin cambios manuales en código nativo.

## Technical Notes

### Paquetes recomendados

Usar los dos paquetes estándar de la comunidad Flutter para
esta tarea. Ambos son mantenidos activamente y cubren
Android e iOS:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.x
  flutter_native_splash: ^2.x.x
```

> Estos van en `dev_dependencies`, no en `dependencies`,
> ya que son herramientas de generación de código, no
> librerías de runtime.

---

### Configuración de flutter_launcher_icons en pubspec.yaml

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/app_icon.png"
  min_sdk_android: 21

  # Ícono adaptativo Android
  adaptive_icon_background: "#FFFFFF"   # ← ajustar al color de la app
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"

  # Ícono monocromático Android 13+ (opcional)
  # adaptive_icon_monochrome: "assets/images/app_icon_monochrome.png"

  # iOS
  remove_alpha_ios: true   # App Store rechaza íconos con canal alpha en iOS
```

Comando de generación:

```bash
dart run flutter_launcher_icons
```

---

### Configuración de flutter_native_splash en pubspec.yaml

```yaml
flutter_native_splash:
  color: "#FFFFFF"              # ← fondo Light: ajustar al color de la app
  color_dark: "#121212"         # ← fondo Dark: ajustar al color de la app
  image: assets/images/app_icon.png
  darkmode_image: assets/images/app_icon.png  # puede ser variante diferente

  # Tamaño del logo en la splash (porcentaje del ancho de pantalla)
  image_full_screen: false
  fill: false

  android_12:
    # Android 12+ usa su propio sistema de Splash Screen nativo
    image: assets/images/app_icon.png
    color: "#FFFFFF"
    color_dark: "#121212"
    icon_background_color: "#FFFFFF"
    icon_background_color_dark: "#121212"

  ios: true
  web: false   # ajustar si la app también es web
```

Comando de generación:

```bash
dart run flutter_native_splash:create
```

Para revertir a la Splash Screen por defecto si algo falla:

```bash
dart run flutter_native_splash:remove
```

---

### Inicialización en main.dart

`flutter_native_splash` requiere una línea en `main()` para
preservar la Splash Screen nativa hasta que Flutter esté listo:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  // ... inicialización de providers, base de datos, etc.

  FlutterNativeSplash.remove(); // ← quitar splash cuando todo esté listo
  runApp(const MyApp());
}
```

> CRÍTICO: Si `FlutterNativeSplash.remove()` no se llama,
> la Splash Screen permanece visible indefinidamente.

---

### Assets requeridos antes de ejecutar el SPEC

| Asset | Resolución mínima | Descripción |
|---|---|---|
| `assets/images/app_icon.png` | 1024×1024px | Ícono principal |
| `assets/images/app_icon_foreground.png` | 1024×1024px | Capa foreground del Adaptive Icon Android |

El archivo `app_icon_foreground.png` debe tener fondo transparente
y el logo centrado ocupando máximo el 66% del área total para
evitar recortes en el Adaptive Icon de Android.

---

### Orden de ejecución de comandos

```bash
# 1. Generar íconos del launcher
dart run flutter_launcher_icons

# 2. Generar Splash Screen nativa
dart run flutter_native_splash:create

# 3. Limpiar build anterior (importante)
flutter clean

# 4. Reconstruir
flutter pub get
flutter run
```

> `flutter clean` es obligatorio después de cambiar assets
> nativos. Sin este paso los íconos anteriores pueden
> persistir en el build.

---

### Archivos afectados

**Modificados por los generadores (no editar manualmente):**

- `android/app/src/main/res/mipmap-*/`
- `android/app/src/main/res/drawable*/`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Modificados manualmente:**

- `pubspec.yaml` (configuración de ambos paquetes)
- `lib/main.dart` (inicialización de flutter_native_splash)

**Creados por el equipo antes de ejecutar:**

- `assets/images/app_icon.png`
- `assets/images/app_icon_foreground.png`

## Dependencias

- Ninguna dependencia con otros SPECs pendientes.
- BLOQUEANTE: Los assets `app_icon.png` y
  `app_icon_foreground.png` deben existir antes de ejecutar
  `/opsx-propose`. Sin ellos, los comandos de generación fallan.
- Recomendación: ejecutar este SPEC en un branch separado
  `feature/spec-013-app-icon-splash` y verificar visualmente
  en dispositivo físico antes de hacer merge, ya que los
  cambios en assets nativos no son visibles en el emulador
  con total fidelidad.

---

## Nota operativa importante antes de ejecutar este SPEC

Este es el único SPEC del conjunto que **requiere trabajo previo tuyo** antes de pasarlo al agente: los archivos de imagen deben existir en `assets/images/` antes de ejecutar `/opsx-propose`. Si el agente intenta correr los comandos de generación sin los PNGs, fallará.

El flujo correcto es:
Tú provees los PNGs → /opsx-propose → /opsx-apply →
dart run flutter_launcher_icons →
dart run flutter_native_splash:create →
flutter clean → flutter run → verificar en dispositivo físico
