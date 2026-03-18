# Arteria Fit - Release Build Script for Windows (PowerShell)
# Equivalent of build_release_linux.sh

$ErrorActionPreference = "Stop"

# ─── Resolver raíz del proyecto (carpeta padre del script) ───────────────────
$SCRIPT_DIR  = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_DIR = Split-Path -Parent $SCRIPT_DIR
Set-Location $PROJECT_DIR

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Arteria Fit - Release Build"            -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Generar el APK en release
Write-Host "[1/4] Building release APK..." -ForegroundColor Yellow
flutter build apk --release --dart-define=IS_PRODUCTION=true

# 2. Ubicación del APK generado por Flutter
$APK_PATH = Join-Path $PROJECT_DIR "build\app\outputs\flutter-apk\app-release.apk"

# 3. Verificar que existe
if (-not (Test-Path $APK_PATH)) {
    Write-Host "❌ No se encontró el APK en $APK_PATH" -ForegroundColor Red
    exit 1
}

# 4. Leer versión del pubspec.yaml
Write-Host "[2/4] Leyendo versión de pubspec.yaml..." -ForegroundColor Yellow
$pubspecContent = Get-Content (Join-Path $PROJECT_DIR "pubspec.yaml") -Raw
if ($pubspecContent -match 'version:\s*([\d.]+)\+(\d+)') {
    $VERSION_NAME = $matches[1]
    $VERSION_CODE = $matches[2]
} else {
    $VERSION_NAME = "1.0.0"
    $VERSION_CODE = "1"
}

# 5. Generar nombre con timestamp (mismo formato que el script de Linux)
$DATE       = Get-Date -Format "yyyyMMdd_HHmm"
$NEW_NAME   = "arteria_fit_app-release-v${VERSION_NAME}+${VERSION_CODE}-${DATE}.apk"
$OUTPUT_DIR = Join-Path $PROJECT_DIR "build\app\outputs\flutter-apk"

# 6. Copiar y renombrar
Write-Host "[3/4] Copiando y renombrando APK..." -ForegroundColor Yellow
Copy-Item -Path $APK_PATH -Destination (Join-Path $OUTPUT_DIR $NEW_NAME) -Force

Write-Host ""
Write-Host "✅ APK compilado y renombrado correctamente:" -ForegroundColor Green
Write-Host "   Archivo : $NEW_NAME"          -ForegroundColor White
Write-Host "   Versión : $VERSION_NAME"      -ForegroundColor White
Write-Host "   Build   : $VERSION_CODE"      -ForegroundColor White
Write-Host "   Fecha   : $DATE"              -ForegroundColor White
Write-Host "   Ruta    : $OUTPUT_DIR\$NEW_NAME" -ForegroundColor White
Write-Host ""

# 7. Listar todos los APKs de release
Write-Host "[4/4] APKs de release disponibles:" -ForegroundColor Yellow
Get-ChildItem -Path $OUTPUT_DIR -Filter "arteria_fit_app-release*.apk" | ForEach-Object {
    Write-Host "   $($_.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "¡Listo!" -ForegroundColor Green
