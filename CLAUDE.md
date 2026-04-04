# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fido Scanner V2 is an Android app that scans FIDO2 QR codes for cross-device passkey authentication. When a PC displays a FIDO QR code, this app scans it and hands the `FIDO:/` URI off to the device's credential manager/password manager to complete the passkey flow. Built with Kotlin and Jetpack Compose. Targets API 36 (minSdk 31), uses Material 3.

## Build Commands

```bash
# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# Run unit tests
./gradlew test

# Run a single unit test class
./gradlew testDebugUnitTest --tests "com.example.fidoscannerv2.ExampleUnitTest"

# Run instrumented tests (requires connected device/emulator)
./gradlew connectedAndroidTest

# Clean build
./gradlew clean
```

## Architecture

- **Single-module Gradle project** with one `:app` module
- **Jetpack Compose UI** with Material 3 — no XML layouts
- **Version catalog** at `gradle/libs.versions.toml` for dependency management
- **Package**: `com.example.fidoscannerv2`
- **Entry point**: `MainActivity` — single activity, all UI logic in one file (`MainActivity.kt`)
- No ViewModel, no navigation library — plain Compose state (`mutableStateOf`)

## Key Files

- `app/src/main/java/com/example/fidoscannerv2/MainActivity.kt` — entire app logic: permission handling, camera preview (`CameraPreview` composable), QR analysis (`QrAnalyzer`), FIDO dialog, and intent handoff
- `app/src/main/AndroidManifest.xml` — declares `CAMERA` permission and `uses-feature`
- `gradle/libs.versions.toml` — version catalog for all dependencies
- `.github/workflows/release.yml` — builds and signs release APK, publishes GitHub Release on `v*` tag push
- `.github/workflows/tag.yml` — manual `workflow_dispatch` to create and push a `vX.Y.Z` tag (triggers `release.yml`); requires `PAT` secret
- `docs/index.html` — GitHub Pages landing page with dynamic APK download button (served at `https://the-lukez.github.io/fido-scanner-v2/`)

## Distribution

- **GitHub Releases** — signed APK attached as `fido-scanner-vX.Y.Z.apk` on each release
- **GitHub Pages** — `docs/index.html` served from `main:/docs`, fetches latest release via GitHub API
- **Release signing** — `app/build.gradle.kts` reads keystore credentials from env vars (`KEYSTORE_PATH`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`); stored as GitHub Actions secrets (`KEYSTORE_BASE64`, etc.)
- To publish: run the `Create Tag` workflow dispatch with the version number, or manually `git tag vX.Y.Z && git push origin vX.Y.Z`

## Key Technical Details

- Kotlin with Compose compiler plugin (no separate `kotlinOptions.jvmTarget` — uses `compileOptions` with Java 11)
- AGP 9.0.1 with the new `compileSdk { version = release(36) }` syntax
- Edge-to-edge display enabled via `enableEdgeToEdge()`
- Compose BOM 2026.03.01 manages all Compose library versions
- **CameraX 1.4.2** — `camera-core`, `camera-camera2`, `camera-lifecycle`, `camera-view` (PreviewView wrapped in `AndroidView`)
- **ML Kit barcode-scanning 17.3.0** — bundled model (offline), `FORMAT_QR_CODE` only, 1-second debounce
- FIDO URI handoff via `Intent(ACTION_VIEW, Uri.parse(fidoUri))` — the OS/credential manager handles CTAP2
- **Minification enabled** (`isMinifyEnabled = true`) — `app/proguard-rules.pro` keeps `Camera2Config$DefaultProvider` (ServiceLoader entry point) and the `analyze()` method on `ImageAnalysis.Analyzer` implementations; all directly referenced CameraX/ML Kit API classes are kept automatically by R8
