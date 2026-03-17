@echo off
REM Arteria Fit - Release Build Script for Windows
REM Batch version

echo ==========================================
echo    Arteria Fit - Release Build
echo ==========================================
echo.

REM 1. Generar el APK en release
echo [1/5] Building release APK...
flutter build apk --release --dart-define=IS_PRODUCTION=true
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed!
    exit /b 1
)

REM 2. Ubicación del APK generado por Flutter
set APK_PATH=build\app\outputs\flutter-apk\app-release.apk

REM 3. Verificar que existe
if not exist "%APK_PATH%" (
    echo ❌ No se encontró el APK en %APK_PATH%
    exit /b 1
)

REM 4. Leer versión del pubspec.yaml
echo [2/5] Reading version from pubspec.yaml...
for /f "tokens=2 delims= " %%a in ('findstr /b "version:" pubspec.yaml') do set FULL_VERSION=%%a
for /f "tokens=1,2 delims=+" %%a in ("%FULL_VERSION%") do (
    set VERSION_NAME=%%a
    set VERSION_CODE=%%b
)

if not defined VERSION_CODE set VERSION_CODE=1
if not defined VERSION_NAME set VERSION_NAME=1.0.0

REM 5. Generar nombre con timestamp
for /f "tokens=1-4 delims=/ " %%a in ("%date% %time%") do (
    set DATE=%%a%%b%%c_%%d
)
set DATE=%DATE::=%
set DATE=%DATE: =%
set DATE=%DATE:/=%

set NEW_NAME=arteria_fit_app-release-v%VERSION_NAME%+%VERSION_CODE%-%DATE%.apk

REM 6. Copiar y renombrar
echo [3/5] Copying and renaming APK...
copy /Y "%APK_PATH%" "build\app\outputs\flutter-apk\%NEW_NAME%"

echo.
echo ✅ APK successfully built and renamed:
echo    File: %NEW_NAME%
echo    Version: %VERSION_NAME%
echo    Build: %VERSION_CODE%
echo    Date: %DATE%
echo    Path: build\app\outputs\flutter-apk\%NEW_NAME%
echo.
echo [4/5] Listing all release APKs:
dir /b build\app\outputs\flutter-apk\arteria_fit_app-release*.apk
echo.
echo [5/5] Done!
