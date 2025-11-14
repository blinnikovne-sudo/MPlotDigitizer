# Сборка APK локально

## Проблема с текущей средой

В данный момент APK не может быть собран в текущей среде из-за отсутствия доступа к интернету.
Gradle требует доступ к следующим ресурсам:
- `services.gradle.org` - для загрузки Gradle
- `dl.google.com` - для Android Build Tools
- `repo.maven.apache.org` - для Maven зависимостей

## Решение: Сборка в локальной среде

Для сборки APK вам потребуется окружение с доступом к интернету.

### Системные требования

1. **Java Development Kit (JDK)**
   - Версия: JDK 17 или новее
   - Проверка: `java -version`

2. **Node.js и npm**
   - Версия: Node.js 18 или новее
   - Проверка: `node -v && npm -v`

3. **Android SDK** (опционально)
   - Gradle wrapper автоматически загрузит необходимые компоненты
   - Или установите Android Studio

4. **Интернет соединение**
   - Для загрузки Gradle и зависимостей
   - Требуется только при первой сборке

### Пошаговая инструкция

#### 1. Клонирование репозитория

```bash
git clone <repository-url>
cd MPlotDigitizer
git checkout claude/wrap-application-01UBpcLXRAs8Gq2GH6TbD4ug
```

#### 2. Установка зависимостей

```bash
npm install
```

#### 3. Сборка APK

```bash
# Используйте автоматический скрипт
./build-apk.sh

# Или пошагово
npm run build                  # Собрать веб-приложение
npm run android:sync           # Синхронизация с Android проектом
npm run android:build          # Собрать debug APK
```

#### 4. Проверка результата

После успешной сборки APK будет находиться в:
- `android/app/build/outputs/apk/debug/app-debug.apk`
- `apk-releases/debug/webplotdigitizer-v5.3.0-debug.apk`

Проверьте размер файла:
```bash
ls -lh apk-releases/debug/*.apk
```

Должен быть ~5-20 MB в зависимости от содержимого.

#### 5. Тестирование APK

Установите APK на устройство или эмулятор:
```bash
adb install apk-releases/debug/webplotdigitizer-v5.3.0-debug.apk
```

Или используйте Android Studio:
```bash
npm run android:open
```

#### 6. Коммит APK в репозиторий

После успешной сборки и тестирования:

```bash
# Добавить APK в git
git add apk-releases/debug/*.apk

# Создать коммит
git commit -m "Add WebPlotDigitizer v5.3.0 debug APK

Built on: $(date)
Size: $(ls -lh apk-releases/debug/*.apk | awk '{print $5}')
Platform: Android (API 21+)
"

# Запушить изменения
git push
```

### Сборка Release версии

Для продакшен релиза требуется подписание APK:

#### 1. Создание keystore

```bash
keytool -genkey -v \
  -keystore wpd-release-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias wpd-key
```

**ВАЖНО:** Сохраните пароли в безопасном месте!

#### 2. Настройка подписания

Создайте файл `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=wpd-key
storeFile=../wpd-release-key.jks
```

#### 3. Обновление build.gradle

Отредактируйте `android/app/build.gradle`:

```gradle
// После "android {" добавьте:

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... существующая конфигурация ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 4. Сборка подписанного APK

```bash
npm run android:build:release

# Копирование в директорию релизов
VERSION=$(node -pe "require('./package.json').version")
cp android/app/build/outputs/apk/release/app-release.apk \
   apk-releases/release/webplotdigitizer-v${VERSION}-release.apk
```

#### 5. Проверка подписи

```bash
jarsigner -verify -verbose -certs \
  apk-releases/release/webplotdigitizer-v5.3.0-release.apk
```

### Автоматизация с CI/CD

Для автоматической сборки можно использовать GitHub Actions:

Создайте `.github/workflows/build-apk.yml`:

```yaml
name: Build Android APK

on:
  push:
    branches: [ main, release/* ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'

    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'

    - name: Install dependencies
      run: npm install

    - name: Build APK
      run: ./build-apk.sh

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: webplotdigitizer-debug-apk
        path: apk-releases/debug/*.apk
```

### Устранение проблем

#### Ошибка: "SDK location not found"

Создайте `android/local.properties`:
```properties
sdk.dir=/path/to/Android/Sdk
```

#### Ошибка: OutOfMemoryError

Увеличьте heap для Gradle в `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m
```

#### Ошибка: "Failed to install"

Очистите кэш:
```bash
cd android
./gradlew clean
cd ..
npm run android:build
```

## Дополнительная информация

- [Документация Android Studio](https://developer.android.com/studio)
- [Подписание приложений Android](https://developer.android.com/studio/publish/app-signing)
- [Документация Capacitor](https://capacitorjs.com/docs/android)
