#!/bin/bash

# Скрипт для сборки APK через Docker
# Использует предустановленный Android SDK в Docker образе

set -e

echo "========================================="
echo "Building APK using Docker"
echo "========================================="
echo ""

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker не установлен!"
    echo "Установите Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Сборка Docker образа
echo "[1/2] Сборка Docker образа с Android SDK..."
docker build -f Dockerfile.android -t webplotdigitizer-android .

# Запуск сборки APK
echo "[2/2] Сборка APK внутри контейнера..."
docker run --rm \
    -v "$(pwd)/apk-releases:/app/apk-releases" \
    -v "$(pwd)/android:/app/android" \
    webplotdigitizer-android

echo ""
echo "========================================="
echo "Сборка завершена!"
echo "========================================="
echo ""
echo "APK файл:"
ls -lh apk-releases/debug/*.apk 2>/dev/null || echo "APK не найден"
