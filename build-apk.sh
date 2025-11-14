#!/bin/bash

# Скрипт для автоматической сборки Android APK
# WebPlotDigitizer

set -e  # Остановить при ошибке

echo "========================================="
echo "WebPlotDigitizer APK Build Script"
echo "========================================="
echo ""

# 1. Сборка веб-приложения
echo "[1/5] Сборка веб-приложения..."
npm run build

# 2. Подготовка www директории
echo "[2/5] Подготовка www директории..."
rm -rf www
mkdir -p www
cp *.html www/ 2>/dev/null || true
cp *.js www/ 2>/dev/null || true
cp -r styles www/ 2>/dev/null || true
cp -r images www/ 2>/dev/null || true
cp -r node_modules www/ 2>/dev/null || true
cp favicon.ico www/ 2>/dev/null || true

# 3. Синхронизация с Capacitor
echo "[3/5] Синхронизация с Capacitor..."
npx cap sync android

# 4. Сборка APK
echo "[4/5] Сборка APK..."
cd android
./gradlew assembleDebug

# 5. Вывод результата
echo ""
echo "========================================="
echo "[5/5] Сборка завершена!"
echo "========================================="
echo ""
echo "APK файл находится в:"
echo "android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "Для установки на устройство выполните:"
echo "adb install android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
