## Why

The app currently uses Flutter's default launcher icon (the Flutter logo) and default splash screen. This does not reflect the app's branding or purpose (cardiovascular health, breathing exercises, and nutrition). A consistent visual identity with a custom icon and branded splash screen improves user experience and professional appearance.

## What Changes

- Replace the default Flutter launcher icon with a custom Arteria Fit icon for Android and iOS
- Implement adaptive icon support for Android (API 26+) with foreground/background layers
- Create a custom native splash screen showing the app logo with branded colors
- Support Light/Dark mode variants for the splash screen background
- Add optional monochrome icon support for Android 13+ Themed Icons

## Capabilities

### New Capabilities

- `app-launcher-icon`: Custom launcher icon generation and configuration for Android and iOS with adaptive icon support
- `native-splash-screen`: Custom splash screen with branded colors and Light/Dark mode support

### Modified Capabilities

<!-- No existing capability requirements are being modified -->

## Impact

- **Dependencies**: Add `flutter_launcher_icons` and `flutter_native_splash` as dev dependencies
- **Configuration**: Update `pubspec.yaml` with asset paths and color configurations
- **Code**: Modify `lib/main.dart` to integrate splash screen preservation/removal
- **Assets**: Source PNG files at `assets/logo/` (already provided)
- **Generated files**: Native Android (`mipmap-*`, `drawable*`) and iOS (`Assets.xcassets`, `LaunchScreen.storyboard`) will be auto-generated
