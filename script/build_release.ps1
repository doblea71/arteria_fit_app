# Arteria Fit - Release Build Script for Windows (PowerShell)
# Updated to support --split-per-abi with custom renaming

$ErrorActionPreference = "Stop"

# ─── Resolver raíz del proyecto (carpeta padre del script) ───────────────────
$SCRIPT_DIR  = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_DIR = Split-Path -Parent $SCRIPT_DIR
Set-Location $PROJECT_DIR

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Arteria Fit - Release Build (Split APK)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Generar los APKs split en release
Write-Host "[1/4] Building release APKs (split-per-abi)..." -ForegroundColor Yellow
flutter build apk --release --split-per-abi --dart-define=IS_PRODUCTION=true

# 2. Directorio de salida
$OUTPUT_DIR = Join-Path $PROJECT_DIR "build\app\outputs\flutter-apk"

# 3. Leer versión del pubspec.yaml
Write-Host "[2/4] Leyendo versión de pubspec.yaml..." -ForegroundColor Yellow
$pubspecContent = Get-Content (Join-Path $PROJECT_DIR "pubspec.yaml") -Raw
if ($pubspecContent -match 'version:\s*([\d.]+)\+(\d+)') {
    $VERSION_NAME = $matches[1]
    $VERSION_CODE = $matches[2]
} else {
    $VERSION_NAME = "1.0.0"
    $VERSION_CODE = "1"
}

# 4. Procesar y renombrar cada APK generado
Write-Host "[3/4] Procesando y renombrando APKs..." -ForegroundColor Yellow
$DATE = Get-Date -Format "yyyyMMdd"
$ABIs = @("armeabi-v7a", "arm64-v8a", "x86_64")

foreach ($ABI in $ABIs) {
    $OLD_NAME = "app-$ABI-release.apk"
    $OLD_PATH = Join-Path $OUTPUT_DIR $OLD_NAME
    
    if (Test-Path $OLD_PATH) {
        $NEW_FILENAME = "ArteriaFit-v$VERSION_NAME+$VERSION_CODE-$ABI.apk"
        $NEW_PATH = Join-Path $OUTPUT_DIR $NEW_FILENAME
        
        Copy-Item -Path $OLD_PATH -Destination $NEW_PATH -Force
        Write-Host "   ✅ Generado: $NEW_FILENAME" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️ No se encontró: $OLD_NAME (esto es normal si no se seleccionó el ABI)" -ForegroundColor Gray
    }
}

# 5. También renombrar el fat APK si existe (opcional, flutter build apk --split-per-abi suele no generarlo o dejarlo como app-release.apk)
$FAT_APK = Join-Path $OUTPUT_DIR "app-release.apk"
if (Test-Path $FAT_APK) {
    $NEW_FAT_NAME = "ArteriaFit-v$VERSION_NAME+$VERSION_CODE-universal.apk"
    Copy-Item -Path $FAT_APK -Destination (Join-Path $OUTPUT_DIR $NEW_FAT_NAME) -Force
    Write-Host "   ✅ Generado: $NEW_FAT_NAME (Universal)" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Resumen de Build"                        -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Versión : $VERSION_NAME"      -ForegroundColor White
Write-Host "   Build   : $VERSION_CODE"      -ForegroundColor White
Write-Host "   Ruta    : $OUTPUT_DIR"        -ForegroundColor White
Write-Host ""

# 6. Listar solo los archivos nuevos
Write-Host "[4/4] Archivos finales disponibles:" -ForegroundColor Yellow
Get-ChildItem -Path $OUTPUT_DIR -Filter "ArteriaFit-v*.apk" | ForEach-Object {
    Write-Host "   $($_.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "¡Listo!" -ForegroundColor Green
