# Fido Scanner V2

An Android app for scanning FIDO2 QR codes to enable cross-device passkey authentication on phones that don't support it natively.

## What it does

When you're signing in on a PC, it can display a FIDO QR code asking a nearby phone to authenticate. This app scans that QR code and hands the `FIDO:/` URI to your phone's password manager (Google Password Manager, Samsung Pass, etc.), which then completes the passkey flow automatically.

The app does **not** implement CTAP2 itself — it bridges the camera scan to the OS credential system.

### Is this a public app or what?

No, at least not yet. This is a proof-of-concept app to demonstrate the idea and test the flow. If there's interest, it could be polished and released on the Play Store in the future. Since a Google developer account is required to publish apps, and I don't have one yet, the app is currently only available as an APK that can be sideloaded.

## Flow

1. Open the app → tap **Scan QR Code**
2. Grant camera permission on first use
3. Point the camera at the FIDO QR code on your PC
4. A dialog appears: **Open** or **Dismiss**
5. Tap **Open** → your password manager takes over

## Requirements

- Android 12+ (minSdk 31)
- A credential manager / password manager installed that handles `FIDO:/` URIs (e.g. Google Play Services with Google Password Manager)

## Building

```bash
# Debug APK
./gradlew assembleDebug

# Release APK
./gradlew assembleRelease
```

APK output: `app/build/outputs/apk/debug/app-debug.apk`

## Tech stack

- Kotlin + Jetpack Compose + Material 3
- CameraX 1.4.2 for camera preview
- ML Kit barcode-scanning 17.3.0 for QR detection

## TODO

- Optimize apk size (46MB)

  - add `shrinkResources: true`
  - use ML Kit Unbundled

- Add update functionality (fetch latest release tag and ask user to update)
