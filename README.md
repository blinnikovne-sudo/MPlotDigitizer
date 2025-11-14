# WebPlotDigitizer

A large quantity of useful data is locked away in images of data visualizations. WebPlotDigitizer is a computer vision assisted software that helps extract numerical data from images of a variety of data visualizations.

WPD has been used by thousands in academia and industry since its creation in 2010 (Google Scholar Citations)

To use WPD, sign-up on https://automeris.io

![WPD Screenshot](images/wpd5.png "WebPlotDigitizer UI")

## Donate

Donatations help keeping WPD free for thousands of scientists and researchers across the world.

<a href='https://ko-fi.com/L4L010CWIY' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi6.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

## Documentation

Visit: https://automeris.io/docs/

## License

WPD frontend is distributed under GNU AGPL v3 license (this repository). 

Automeris "AI Assist" and other related cloud based systems are closed source and owned by Automeris LLC (owned by Ankit Rohatgi).

## Contact

Primary Author and Maintainer: Ankit Rohatgi

Email: plots@automeris.io

## Contributions

WPD does not have an official roadmap. Please consult before submitting contributions.


## Local build (for development)

With Docker:
```
docker compose up --build               # install depedencies, build and host
docker compose run wpd npm run build    # rebuild
docker compose run wpd npm run format   # autoformat code
http://localhost:8080/tests             # run tests
```

Without Docker:
```
npm install     # install dependencies
npm run build   # build artifacts
npm start       # host locally
npm run format  # autoformat code
npm run test    # run tests
```

## Android APK Build

### Method 1: Docker (Recommended)
```bash
./build-apk-docker.sh          # One command build with Docker
```

### Method 2: Local build (requires Android SDK)
```bash
./build-apk.sh                 # Quick build using script

# Or step by step
npm run build                  # Build web app
npm run android:sync          # Sync with Android project
npm run android:build         # Build debug APK
```

### Method 3: GitHub Actions (CI/CD)
Push to repository and GitHub will automatically build APK.

**Documentation:**
- [BUILD_APK.md](BUILD_APK.md) - Standard build instructions
- [ALTERNATIVE_BUILD_METHODS.md](ALTERNATIVE_BUILD_METHODS.md) - Docker, CI/CD, PWA options
- [BUILDING_APK_LOCALLY.md](BUILDING_APK_LOCALLY.md) - Detailed local setup

The APK will be located at: `apk-releases/debug/webplotdigitizer-v5.3.0-debug.apk`
