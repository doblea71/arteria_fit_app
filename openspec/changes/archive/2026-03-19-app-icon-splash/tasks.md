## 1. Dependencies Setup

- [x] 1.1 Add `flutter_launcher_icons: ^0.14.2` to dev_dependencies in pubspec.yaml
- [x] 1.2 Add `flutter_native_splash: ^2.4.0` to dev_dependencies in pubspec.yaml
- [x] 1.3 Run `flutter pub get`

## 2. Asset Configuration

- [x] 2.1 Configure flutter_launcher_icons in pubspec.yaml with asset paths
- [x] 2.2 Configure flutter_native_splash in pubspec.yaml with colors and asset paths
- [x] 2.3 Create assets/images directory if needed
- [x] 2.4 Copy app_icon.png to assets/images/ (or use assets/logo/)

## 3. Main.dart Integration

- [x] 3.1 Add `import 'package:flutter_native_splash/flutter_native_splash.dart';` to main.dart
- [x] 3.2 Add `FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);` after WidgetsFlutterBinding.ensureInitialized()
- [x] 3.3 Add `FlutterNativeSplash.remove();` after providers are initialized but before runApp()

## 4. Icon Generation

- [x] 4.1 Run `dart run flutter_launcher_icons` to generate launcher icons
- [x] 4.2 Verify generated icons in android/app/src/main/res/mipmap-*/
- [x] 4.3 Verify generated icons in ios/Runner/Assets.xcassets/AppIcon.appiconset/

## 5. Splash Screen Generation

- [x] 5.1 Run `dart run flutter_native_splash:create` to generate splash screens
- [x] 5.2 Verify generated splash in android/app/src/main/res/drawable*/
- [x] 5.3 Verify generated splash in ios/Runner/Base.lproj/LaunchScreen.storyboard
- [x] 5.4 Run `flutter clean` to clear build cache

## 6. Verification

- [x] 6.1 Run `flutter analyze` to verify no issues
- [x] 6.2 Test on physical Android device (icons may not show correctly on emulator)
- [x] 6.3 Test on physical iOS device (icons may not show correctly on simulator)
- [x] 6.4 Verify Light mode splash shows correct background color
- [x] 6.5 Verify Dark mode splash shows correct background color
