# app-launcher-icon

## ADDED Requirements

### Requirement: Custom launcher icon replaces default Flutter icon

The system SHALL replace the default Flutter launcher icon with a custom Arteria Fit icon on both Android and iOS platforms. The icon SHALL be generated in all required resolutions for each platform from a single source PNG file at `assets/logo/arteria-fit.png`.

#### Scenario: Android launcher displays custom icon

- **WHEN** user views the app in Android launcher
- **THEN** the Arteria Fit icon is displayed in the shape applied by the launcher (circle, squircle, square)

### Requirement: Adaptive icon support for Android 8.0+

On Android devices running API 26+, the launcher icon SHALL be implemented as an Adaptive Icon with:

- A foreground layer containing the Arteria Fit logo/icon
- A background layer with a solid color matching the app theme

#### Scenario: Adaptive icon renders correctly on Android 10

- **WHEN** device runs Android 10 with a square launcher mask
- **THEN** the Arteria Fit icon appears within the mask boundaries with proper padding

### Requirement: iOS icon in all required resolutions

The system SHALL generate launcher icons for iOS in all resolutions required by iOS (20pt to 1024pt) and the App Store.

#### Scenario: iOS App Icon in all sizes

- **WHEN** iOS generates icons for device and App Store
- **THEN** all required sizes from 20pt to 1024pt are generated without manual intervention

### Requirement: Alpha channel removal for iOS

The system SHALL remove alpha channel from iOS icons as required by App Store submission guidelines.

#### Scenario: iOS icons pass App Store validation

- **WHEN** App Store validates the app bundle
- **THEN** no icon is rejected due to alpha channel issues
