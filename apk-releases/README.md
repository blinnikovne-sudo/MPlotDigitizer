# APK Releases

Эта директория содержит собранные APK файлы для WebPlotDigitizer.

## Структура

```
apk-releases/
├── debug/          # Отладочные APK (для тестирования)
└── release/        # Релизные APK (подписанные, для распространения)
```

## Версии

### v5.3.0
- **Дата:** 2025-11-14
- **Описание:** Первая Android версия WebPlotDigitizer
- **Размер:** ~
- **Файл:** `webplotdigitizer-v5.3.0-debug.apk`

## Как установить

### На устройство через ADB
```bash
adb install apk-releases/debug/webplotdigitizer-v5.3.0-debug.apk
```

### На устройство напрямую
1. Скопируйте APK файл на Android устройство
2. Откройте файл на устройстве
3. Разрешите установку из неизвестных источников (если требуется)
4. Следуйте инструкциям установщика

## Сборка APK

Для создания APK файлов используйте:

```bash
# Debug версия
./build-apk.sh
cp android/app/build/outputs/apk/debug/app-debug.apk apk-releases/debug/webplotdigitizer-v5.3.0-debug.apk

# Release версия (требует подписи)
npm run android:build:release
cp android/app/build/outputs/apk/release/app-release.apk apk-releases/release/webplotdigitizer-v5.3.0-release.apk
```

## Системные требования

- Android 5.0 (API 21) или выше
- ~50 MB свободного места

## Права доступа

Приложение запрашивает следующие права:
- **INTERNET** - для загрузки PDF файлов и изображений
- **READ_EXTERNAL_STORAGE** - для чтения файлов с устройства
- **WRITE_EXTERNAL_STORAGE** - для сохранения результатов

## Известные проблемы

См. основной [README.md](../README.md) и [GitHub Issues](https://github.com/ankitrohatgi/WebPlotDigitizer/issues)
