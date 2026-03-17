# Arteria Fit - Release Build Script for Windows
# PowerShell version

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Arteria Fit - Release Build" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Generar el APK en release
Write-Host "[1/5] Building release APK..." -ForegroundColor Yellow
flutter build apk --release --dart-define=IS_PRODUCTION=true

# 2. Ubicación del APK generado por Flutter
$APK_PATH = "build\app\outputs\flutter-apk\app-release.apk"

# 3. Verificar que existe
if (-not (Test-Path $APK_PATH)) {
    Write-Host "❌ No se encontró el APK en $APK_PATH" -ForegroundColor Red
    exit 1
}

# 4. Leer versión del pubspec.yaml
Write-Host "[2/5] Reading version from pubspec.yaml..." -ForegroundColor Yellow
$pubspecContent = Get-Content "pubspec.yaml" -Raw
if ($pubspecContent -match 'version:\s*([\d.]+)\+(\d+)') {
    $VERSION_NAME = $matches[1]
    $VERSION_CODE = $matches[2]
} else {
    $VERSION_NAME = "1.0.0"
    $VERSION_CODE = "1"
}

# 5. Generar nombre con timestamp
$DATE = Get-Date -Format "yyyyMMdd_HHmmss"
$NEW_NAME = "arteria_fit_app-release-v${VERSION_NAME}+${VERSION_CODE}-${DATE}.apk"
$OUTPUT_DIR = "build\app\outputs\flutter-apk"

# 6. Copiar y renombrar
Write-Host "[3/5] Copying and renaming APK..." -ForegroundColor Yellow
Copy-Item -Path $APK_PATH -Destination "$OUTPUT_DIR\$NEW_NAME" -Force

Write-Host ""
Write-Host "✅ APK successfully built and renamed:" -ForegroundColor Green
Write-Host "   File: $NEW_NAME" -ForegroundColor White
Write-Host "   Version: $VERSION_NAME" -ForegroundColor White
Write-Host "   Build: $VERSION_CODE" -ForegroundColor White
Write-Host "   Date: $DATE" -ForegroundColor White
Write-Host "   Path: $OUTPUT_DIR\$NEW_NAME" -ForegroundColor White
Write-Host ""
Write-Host "[4/5] Listing all release APKs:" -ForegroundColor Yellow
Get-ChildItem -Path $OUTPUT_DIR -Filter "arteria_fit_app-release*.apk" | ForEach-Object {
    Write-Host "   $($_.Name)" -ForegroundColor White
}

Write-Host "[5/5] Done!" -ForegroundColor Green
