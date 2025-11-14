# Сборка Android APK

Это руководство описывает процесс сборки Android APK для WebPlotDigitizer.

> **Примечание:** Если вы собираете APK локально (не в Docker или CI/CD), смотрите подробные инструкции в [BUILDING_APK_LOCALLY.md](BUILDING_APK_LOCALLY.md)

## Требования

Для сборки APK вам потребуется:
- Node.js и npm
- Android Studio или Android SDK (SDK 21+)
- Java Development Kit (JDK 17+)

## Настройка окружения

1. Установите Android SDK и настройте переменные окружения:
```bash
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

2. Установите зависимости:
```bash
npm install
```

## Процесс сборки

### 1. Сборка веб-приложения
```bash
npm run build
```

### 2. Синхронизация с Capacitor
После сборки веб-приложения нужно скопировать файлы в www директорию:
```bash
mkdir -p www
cp *.html www/
cp *.js www/
cp -r styles www/
cp -r images www/
cp -r node_modules www/
cp favicon.ico www/
```

### 3. Синхронизация с Android проектом
```bash
npx cap sync android
```

### 4. Сборка APK

#### Отладочная версия (debug APK)
```bash
cd android
./gradlew assembleDebug
```
APK будет создан в: `android/app/build/outputs/apk/debug/app-debug.apk`

#### Релизная версия (release APK)
```bash
cd android
./gradlew assembleRelease
```
APK будет создан в: `android/app/build/outputs/apk/release/app-release-unsigned.apk`

**Примечание:** Для релизной версии требуется подписание APK. См. раздел "Подписание APK".

## Подписание APK (для релиза)

1. Создайте keystore:
```bash
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

2. Настройте gradle для подписания:
Отредактируйте `android/app/build.gradle` и добавьте:
```gradle
android {
    signingConfigs {
        release {
            storeFile file("path/to/my-release-key.jks")
            storePassword "password"
            keyAlias "my-key-alias"
            keyPassword "password"
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

3. Соберите подписанный APK:
```bash
cd android
./gradlew assembleRelease
```

## Быстрая сборка (скрипт)

Для упрощения процесса создан скрипт `build-apk.sh`:
```bash
./build-apk.sh
```

## Установка APK на устройство

```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

## Открытие проекта в Android Studio

```bash
npx cap open android
```

## Устранение неполадок

### Ошибка: "ANDROID_HOME not set"
Убедитесь, что переменная окружения ANDROID_HOME установлена правильно.

### Ошибка: "SDK location not found"
Создайте файл `android/local.properties` с содержимым:
```
sdk.dir=/path/to/android/sdk
```

### Проблемы с зависимостями Gradle
Попробуйте очистить кэш:
```bash
cd android
./gradlew clean
```

## Дополнительная информация

- [Документация Capacitor](https://capacitorjs.com/docs)
- [Документация Android](https://developer.android.com/studio/build/building-cmdline)
