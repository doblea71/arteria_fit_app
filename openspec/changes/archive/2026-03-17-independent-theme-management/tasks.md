## 1. Dependencias

- [x] 1.1 Agregar `shared_preferences` a pubspec.yaml
- [x] 1.2 Ejecutar `flutter pub get` para instalar la dependencia

## 2. ThemeProvider con Persistencia

- [x] 2.1 Modificar `lib/core/providers/theme_provider.dart` para:
  - [x] 2.1.1 Cargar preferencia guardada al iniciar (usar SharedPreferences)
  - [x] 2.1.2 Guardar preferencia cuando el usuario cambia el tema
  - [x] 2.1.3 Usar ThemeMode.light como valor por defecto si falla lectura
  - [x] 2.1.4 Eliminar ThemeMode.system de las opciones

## 3. Main.dart - Ignorar tema del SO

- [x] 3.1 Modificar `lib/main.dart` para usar solo ThemeMode.light o ThemeMode.dark
- [x] 3.2 Eliminar cualquier referencia a ThemeMode.system

## 4. Screens - Actualizar para ThemeProvider

- [x] 4.1 Actualizar `lib/features/dashboard/dashboard_screen.dart`:
  - [x] 4.1.1 Verificar que usa ThemeProvider para detectar tema
  - [x] 4.1.2 Eliminar hardcoded colores si existen

- [x] 4.2 Actualizar `lib/features/breathing/breathing_screen.dart`:
  - [x] 4.2.1 Reemplazar colores hardcodeados con Theme.of(context)
  - [x] 4.2.2 Usar ThemeProvider para detectar tema actual

- [x] 4.3 Actualizar `lib/features/isometrics/isometrics_screen.dart`:
  - [x] 4.3.1 Verificar uso correcto de ThemeProvider
  - [x] 4.3.2 Eliminar hardcoded colores si existen

- [x] 4.4 Actualizar `lib/features/nutrition/nutrition_screen.dart`:
  - [x] 4.4.1 Verificar uso correcto de ThemeProvider
  - [x] 4.4.2 Eliminar hardcoded colores si existen

## 5. Verificación

- [x] 5.1 Ejecutar `flutter analyze` para verificar errores
- [ ] 5.2 Probar cambio de tema en todas las pantallas
- [ ] 5.3 Probar persistencia cerrando y abriendo la app
- [ ] 5.4 Probar con SO en modo oscuro (app debe respetar preferencia guardada)
