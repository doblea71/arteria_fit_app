# native-splash-screen

## ADDED Requirements

### Requirement: Custom native splash screen on app launch

The system SHALL display a custom native splash screen when the app launches, showing the Arteria Fit logo centered vertically and horizontally with a branded background color. The splash screen SHALL NOT display the Flutter logo or any default framework assets.

#### Scenario: Custom splash displays on app open

- **WHEN** user launches the app from the device
- **THEN** a splash screen with Arteria Fit logo and branded background is displayed

### Requirement: Light mode splash background

The splash screen SHALL display with a light mode background color (`#F6F6F8`) when the device has Light mode active.

#### Scenario: Light mode splash

- **WHEN** device runs in Light mode
- **AND** app launches
- **THEN** splash background color is `#F6F6F8`

### Requirement: Dark mode splash background

The splash screen SHALL display with a dark mode background color (`#0F1623`) when the device has Dark mode active.

#### Scenario: Dark mode splash

- **WHEN** device runs in Dark mode
- **AND** app launches
- **THEN** splash background color is `#0F1623`

### Requirement: Splash screen auto-dismissal on Flutter ready

The splash screen SHALL automatically dismiss as soon as Flutter finishes initialization. There SHALL be no artificial delay or sleep to prolong splash duration.

#### Scenario: Splash dismisses immediately on Flutter ready

- **WHEN** Flutter finishes initializing
- **THEN** the splash screen disappears immediately without artificial delay

### Requirement: Android 12+ splash API support

On Android 12+, the splash screen SHALL use Android's SplashScreen API for proper animation and behavior.

#### Scenario: Android 12 splash animation

- **WHEN** app launches on Android 12+
- **THEN** the splash uses Android's native SplashScreen API with smooth transition to Flutter

### Requirement: iOS LaunchScreen.storyboard splash

On iOS, the splash screen SHALL be implemented via LaunchScreen.storyboard with the app logo and background color.

#### Scenario: iOS launch screen

- **WHEN** app launches on iOS
- **THEN** the native launch screen displays with Arteria Fit branding
