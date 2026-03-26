#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Colores
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}   Arteria Fit - Release Build${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

# 1. Generar el APK en release
echo -e "${YELLOW}[1/4] Building release APK...${NC}"
flutter build apk --release --dart-define=IS_PRODUCTION=true

# 2. Verificar que existe
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ ! -f "$APK_PATH" ]; then
  echo -e "${RED}❌ No se encontró el APK en $APK_PATH${NC}"
  exit 1
fi

# 3. Leer versión del pubspec.yaml
echo -e "${YELLOW}[2/4] Leyendo versión de pubspec.yaml...${NC}"
VERSION_LINE=$(grep "^version:" pubspec.yaml | head -1)
FULL_VERSION=$(echo "$VERSION_LINE" | sed 's/version: //' | tr -d ' ')
VERSION_NAME=$(echo "$FULL_VERSION" | cut -d+ -f1)
VERSION_CODE=$(echo "$FULL_VERSION" | cut -d+ -f2)

if [ -z "$VERSION_CODE" ]; then
  VERSION_CODE="1"
fi

# 4. Generar nombre nuevo
echo -e "${YELLOW}[3/4] Procesando y renombrando APK...${NC}"
DATE=$(date +%Y%m%d)
NEW_NAME="ArteriaFit-v${VERSION_NAME}+${VERSION_CODE}.apk"
cp "$APK_PATH" "build/app/outputs/flutter-apk/$NEW_NAME"
echo -e "   ${GREEN}✅ Generado: $NEW_NAME${NC}"

# 5. Resumen
echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}   Resumen de Build${NC}"
echo -e "${CYAN}==========================================${NC}"
echo -e "   ${WHITE}Versión : $VERSION_NAME${NC}"
echo -e "   ${WHITE}Build   : $VERSION_CODE${NC}"
echo -e "   ${WHITE}Ruta    : build/app/outputs/flutter-apk${NC}"
echo ""

echo -e "${YELLOW}[4/4] Archivo final disponible:${NC}"
ls -lh "build/app/outputs/flutter-apk/ArteriaFit-v${VERSION_NAME}+${VERSION_CODE}.apk" 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'

echo ""
if [ -f "android/key.properties" ]; then
  echo -e "${GREEN}🔐 APK firmado con keystore${NC}"
else
  echo -e "${YELLOW}⚠️  APK SIN FIRMAR (unsigned) - solo para testing${NC}"
fi

echo ""
echo -e "${GREEN}¡Listo!${NC}"
