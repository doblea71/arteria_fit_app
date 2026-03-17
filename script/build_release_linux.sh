#!/bin/bash
set -e

echo "=========================================="
echo "   Arteria Fit - Release Build"
echo "=========================================="
echo ""

# 1. Generar el APK en release
# flutter build apk --release --dart-define=API_HOST=http://47.254.33.141:8082 --dart-define=IS_PRODUCTION=true
flutter build apk --release \
  --dart-define=IS_PRODUCTION=true

# 2. Ubicación del APK generado por Flutter
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

# 3. Verificar que existe
if [ ! -f "$APK_PATH" ]; then
  echo "❌ No se encontró el APK en $APK_PATH"
  exit 1
fi

# 4. Formatear nombre nuevo
# Format: version: 1.0.0+1
VERSION_LINE=$(grep "^version:" pubspec.yaml | head -1)
FULL_VERSION=$(echo "$VERSION_LINE" | sed 's/version: //' | tr -d ' ')
VERSION_NAME=$(echo "$FULL_VERSION" | cut -d+ -f1)
VERSION_CODE=$(echo "$FULL_VERSION" | cut -d+ -f2)

# If version code is empty, use a default
if [ -z "$VERSION_CODE" ]; then
  VERSION_CODE="1"
fi

# Generate new name with timestamp
DATE=$(date +%Y%m%d_%H%M)
NEW_NAME="arteria_fit_app-release-v${VERSION_NAME}+${VERSION_CODE}-${DATE}.apk"

# 5. Copy and rename
cp "$APK_PATH" "build/app/outputs/flutter-apk/$NEW_NAME"

echo ""
echo "✅ APK successfully built and renamed:"
echo "   File: $NEW_NAME"
echo "   Version: $VERSION_NAME"
echo "   Build: $VERSION_CODE"
echo "   Date: $DATE"
echo "   Path: build/app/outputs/flutter-apk/$NEW_NAME"