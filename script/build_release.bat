@echo off
setlocal enabledelayedexpansion
REM Arteria Fit - Release Build Script for Windows
REM Updated to support --split-per-abi with custom renaming

echo ==========================================
echo    Arteria Fit - Release Build (Split)
echo ==========================================
echo.

REM 1. Generar los APKs split en release
echo [1/4] Building release APKs (split-per-abi)...
call flutter build apk --release --split-per-abi --dart-define=IS_PRODUCTION=true
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed!
    exit /b 1
)

REM 2. Ubicación de salida
set OUTPUT_DIR=build\app\outputs\flutter-apk

REM 3. Leer versión del pubspec.yaml
echo [2/4] Reading version from pubspec.yaml...
for /f "tokens=2 delims= " %%a in ('findstr /b "version:" pubspec.yaml') do set FULL_VERSION=%%a
for /f "tokens=1,2 delims=+" %%a in ("%FULL_VERSION%") do (
    set VERSION_NAME=%%a
    set VERSION_CODE=%%b
)

if not defined VERSION_CODE set VERSION_CODE=1
if not defined VERSION_NAME set VERSION_NAME=1.0.0

REM 4. Procesar y renombrar cada APK generado
echo [3/4] Processing and renaming APKs...

set ABIs=armeabi-v7a arm64-v8a x86_64

for %%a in (%ABIs%) do (
    set OLD_NAME=app-%%a-release.apk
    if exist "%OUTPUT_DIR%\!OLD_NAME!" (
        set NEW_FILENAME=ArteriaFit-v%VERSION_NAME%+%VERSION_CODE%-%%a.apk
        copy /Y "%OUTPUT_DIR%\!OLD_NAME!" "%OUTPUT_DIR%\!NEW_FILENAME!"
        echo    ✅ Generated: !NEW_FILENAME!
    )
)

REM 5. Renombrar fat APK si existe
if exist "%OUTPUT_DIR%\app-release.apk" (
    set NEW_FAT_NAME=ArteriaFit-v%VERSION_NAME%+%VERSION_CODE%-universal.apk
    copy /Y "%OUTPUT_DIR%\app-release.apk" "%OUTPUT_DIR%\!NEW_FAT_NAME!"
    echo    ✅ Generated: !NEW_FAT_NAME! (Universal)
)

echo.
echo ==========================================
echo    Build Summary
echo ==========================================
echo    Version: %VERSION_NAME%
echo    Build: %VERSION_CODE%
echo    Path: %OUTPUT_DIR%
echo.
echo [4/4] Listing final files:
dir /b %OUTPUT_DIR%\ArteriaFit-v*.apk
echo.
echo Done!
