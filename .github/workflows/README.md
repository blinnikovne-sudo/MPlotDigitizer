# GitHub Actions Workflows

Этот репозиторий настроен для автоматической сборки Android APK через GitHub Actions.

## Workflows

### 1. `build-android.yml` - Debug APK сборка

**Когда запускается:**
- При push в ветки: `main`, `master`, `claude/**`, `release/**`
- При создании Pull Request
- Вручную через GitHub UI (Actions → Build Android APK → Run workflow)

**Что делает:**
1. Устанавливает JDK 17 и Node.js 20
2. Устанавливает Android SDK
3. Собирает веб-приложение (`npm run build`)
4. Собирает debug APK через Gradle
5. Загружает APK как артефакт (доступен 30 дней)
6. Коммитит APK обратно в репозиторий в `apk-releases/debug/`

**Результат:**
- APK доступен в Artifacts (скачать из GitHub UI)
- APK закоммичен в `apk-releases/debug/webplotdigitizer-v5.3.0-debug.apk`

### 2. `release-apk.yml` - Release APK сборка

**Когда запускается:**
- При создании GitHub Release
- Вручную с указанием версии

**Что делает:**
1. Собирает release APK (неподписанный)
2. Загружает APK как артефакт (доступен 90 дней)
3. Прикрепляет APK к GitHub Release (если создан release)

**Результат:**
- APK доступен в Artifacts
- APK прикреплен к GitHub Release

## Как использовать

### Автоматическая сборка при push

Просто сделайте push в репозиторий:

```bash
git add .
git commit -m "My changes"
git push
```

GitHub автоматически соберет APK. Проверьте статус:
1. Перейдите на GitHub в раздел "Actions"
2. Найдите ваш workflow run
3. Дождитесь завершения (~5-10 минут)
4. Скачайте APK из "Artifacts"

### Ручной запуск

1. Откройте GitHub → Actions
2. Выберите "Build Android APK"
3. Нажмите "Run workflow"
4. Выберите ветку
5. Нажмите "Run workflow"

### Создание релиза

Для создания релизной сборки:

```bash
# Создать git tag
git tag -a v5.3.0 -m "Release version 5.3.0"
git push origin v5.3.0

# Или создать Release через GitHub UI
# Settings → Releases → Create a new release
```

Workflow автоматически соберет и прикрепит APK к релизу.

## Где найти собранный APK

### Вариант 1: GitHub Artifacts

1. GitHub → Actions → выберите workflow run
2. Scroll down → Artifacts
3. Download "webplotdigitizer-debug-apk"

### Вариант 2: В репозитории

После успешной сборки APK будет закоммичен в:
```
apk-releases/debug/webplotdigitizer-v5.3.0-debug.apk
```

Просто сделайте `git pull` для получения.

### Вариант 3: GitHub Releases (для release сборок)

1. GitHub → Releases
2. Найдите нужную версию
3. Download APK из Assets

## Требования

Никаких! GitHub предоставляет все необходимое:
- ✅ Ubuntu runner с предустановленным ПО
- ✅ Интернет для загрузки зависимостей
- ✅ Android SDK автоматически устанавливается
- ✅ Бесплатно для публичных репозиториев

## Время сборки

- Первая сборка: ~8-10 минут (кэширование зависимостей)
- Последующие сборки: ~5-7 минут (используется кэш)

## Ограничения

GitHub Actions для публичных репозиториев:
- ✅ Unlimited minutes
- ✅ Unlimited storage for artifacts (30-90 дней)
- ✅ 20 concurrent jobs

Для приватных репозиториев:
- 2000 minutes/месяц (бесплатный план)
- 500 MB storage

## Отладка

Если сборка не удалась:

1. Откройте failed workflow run
2. Раскройте failed step
3. Посмотрите логи ошибок
4. Исправьте и запушьте снова

Типичные проблемы:
- **Gradle build failed**: проверьте `android/build.gradle`
- **Node build failed**: проверьте `npm run build` локально
- **Permission denied**: проверьте права на `android/gradlew`

## Кэширование

Workflows настроены для кэширования:
- ✅ npm packages (`cache: 'npm'`)
- ✅ Gradle dependencies (`cache: 'gradle'`)
- ✅ Android SDK components

Это ускоряет последующие сборки.

## Безопасность

⚠️ **Release APK неподписанный**

Для production релиза нужно:
1. Создать keystore
2. Добавить secrets в GitHub
3. Настроить signing в `android/app/build.gradle`

См. [BUILDING_APK_LOCALLY.md](../../BUILDING_APK_LOCALLY.md) для инструкций по подписанию.

## Дополнительная информация

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [android-actions/setup-android](https://github.com/android-actions/setup-android)
- [Capacitor Android Documentation](https://capacitorjs.com/docs/android)
