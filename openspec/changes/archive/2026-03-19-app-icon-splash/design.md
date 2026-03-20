## Context

The app needs a professional visual identity through custom launcher icons and a branded splash screen. Flutter's community packages (`flutter_launcher_icons` and `flutter_native_splash`) provide robust, platform-specific generation of these assets without manual intervention.

**Current State:**
- Default Flutter logo as launcher icon
- Default Flutter splash screen

**Assets Available:**
- `assets/logo/arteria-fit.png` - Main logo (1024×1024)
- `assets/logo/logo-arteria-fit.png` - Alternative variant

**Constraints:**
- Android minSdk: 21
- iOS deployment target: standard
- Must support both Light and Dark mode splash backgrounds
- Native splash must not have artificial delay

## Goals / Non-Goals

**Goals:**
- Replace launcher icon on Android and iOS with Arteria Fit branding
- Implement Android Adaptive Icons with foreground/background layers
- Create native splash screen with app logo and branded colors
- Support Light/Dark mode splash backgrounds
- No artificial delays - splash disappears when Flutter is ready

**Non-Goals:**
- Web icon/splash (can be enabled later if needed)
- Custom in-app splash screen (native only)
- Animated splash sequences

## Decisions

### 1. Use `flutter_launcher_icons` for launcher icons

**Decision:** Use `flutter_launcher_icons` ^0.14.x as dev dependency

**Rationale:** Automatically generates all required icon sizes for Android (mipmap-*) and iOS (Assets.xcassets) from a single source PNG. Supports Android adaptive icons with foreground/background layers.

**Alternative:** Manual icon generation - error-prone, requires maintaining multiple resolutions.

### 2. Use `flutter_native_splash` for splash screen

**Decision:** Use `flutter_native_splash` ^2.x.x as dev dependency

**Rationale:** Native splash screen (not a Flutter widget) that shows immediately on app launch. Supports Android 12+ splash API and iOS LaunchScreen.storyboard automatically.

**Alternative:** Custom Flutter widget splash - visible only after Flutter initializes, creating a blank flash.

### 3. Asset configuration paths

**Decision:** Use `assets/logo/` for source assets

```yaml
image_path: "assets/logo/arteria-fit.png"
adaptive_icon_foreground: "assets/logo/arteria-fit.png"
```

**Rationale:** Assets already exist in this location. Foreground icon should have transparent background and logo centered (max 66% of canvas to avoid cropping).

### 4. Color scheme for splash

**Decision:** Match app theme colors from AGENTS.md

- Light mode splash background: `#F6F6F8`
- Dark mode splash background: `#0F1623`

## Risks / Trade-offs

- **[Risk]** Emulators may not show new icons correctly → **Mitigation:** Test on physical devices only (per SPEC-013 recommendation)
- **[Risk]** Android adaptive icon may clip logo if too large → **Mitigation:** Use foreground image with transparent background, logo at 66% max size
- **[Risk]** Splash screen persists if `remove()` not called → **Mitigation:** Ensure `FlutterNativeSplash.remove()` is called after providers initialize in main.dart
