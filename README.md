# NetSpeed

A professional, privacy-friendly internet speed test app built with Flutter — measures real
**Download**, **Upload**, and **Ping** using actual network transfers (no random/fake data),
shows connection type (Wi-Fi / Mobile Data), IP address, saves a local history with charts,
and supports **English** and **Arabic (RTL)**.

---

## 1. App idea

NetSpeed works like Speedtest / Fast.com apps: tap **START TEST**, and the app runs a real
ping → download → upload sequence against a live network endpoint, animates the results in
real time on a circular gauge, then shows a results screen with a quality rating (Excellent /
Very Good / Good / Fair / Poor) for each metric. Every test is saved locally so you can review
trends over time on a chart — no account, no login, no data ever leaves your device except the
test traffic itself.

## 2. Architecture

The project follows a light **Clean Architecture** split into `domain` / `data` /
`presentation` per feature, with **Riverpod** for state management:

```
lib/
├── main.dart                     # entry point: Hive init, iOS ping plugin registration
├── app/                          # MaterialApp, theme, routes
├── core/                         # constants, quality thresholds, errors, utils, services
├── features/
│   ├── speed_test/                # domain (SpeedTestRepository abstraction, entities),
│   │                               # data (real engine implementation), presentation (screens)
│   ├── history/                   # Hive persistence + chart
│   ├── network_info/              # IP / Wi-Fi name / connectivity
│   └── settings/                  # theme, unit, language
└── shared/                        # reusable widgets (gauge, quality badge, connection chip)
```

The key design decision is `SpeedTestRepository` (`lib/features/speed_test/domain/repositories/speed_test_repository.dart`):
an abstract interface with `checkConnection()`, `findBestServer()`, `startPingTest()`,
`startDownloadTest()`, `startUploadTest()`, `runFullTest()`, and `cancelTest()`. The UI and
Riverpod provider only depend on this interface — never on the concrete measurement package —
so the underlying engine (`SpeedTestRepositoryImpl`) can be swapped out later without touching
any screen or state-management code.

State is modelled as an explicit machine (`SpeedTestPhase`): `idle → checkingConnection →
findingServer → testingPing → testingDownload → testingUpload → completed / cancelled / error`.

## 3. Packages used and why

| Package | Why |
|---|---|
| `flutter_riverpod` | Modern, testable, compile-safe state management (Notifier/StreamProvider/FutureProvider). |
| `flutter_internet_speed_test_pro` | Actively maintained fork of `flutter_internet_speed_test`, updated for AGP 8+/current Flutter, measures real Download/Upload against Fast.com (Netflix) test infrastructure with live progress callbacks. |
| `dart_ping` + `dart_ping_ios` | Real ICMP ping/latency measurement on both Android and iOS (iOS requires the small native `dart_ping_ios` companion, registered once in `main.dart`). |
| `connectivity_plus` | Detects Wi-Fi / Mobile Data / Ethernet / none, and connectivity change events. |
| `network_info_plus` | Reads device Wi-Fi IP address and Wi-Fi SSID without requesting location permission on most OS versions. |
| `hive` / `hive_flutter` | Fast, dependency-light local key-value storage for the test history — no native SQL setup needed. |
| `fl_chart` | Lightweight, well-maintained charting for the History screen (Download/Upload/Ping line chart). |
| `package_info_plus` | Displays the real app version in Settings. |
| `intl` + `flutter_localizations` | Official Flutter localization pipeline (`.arb` files, generated `AppLocalizations`), with correct RTL support for Arabic. |
| `uuid`, `equatable` | Small utilities for unique history IDs and value-equality on state/entities. |

> **How the speed test actually works:** Download/Upload are measured by transferring real
> data to/from Fast.com's (Netflix) speed-test infrastructure via `flutter_internet_speed_test_pro`
> — the same approach used by many production speed-test apps. Ping is measured with real ICMP
> echo requests to `8.8.8.8`. No `Random()` or simulated values are used anywhere in the app.

## 4. Requirements

- Flutter **3.22.0** or newer (tested against the 3.22–3.24 stable channel)
- Dart **3.4.0** or newer (bundled with the Flutter SDK above)
- Android Studio (or VS Code + Flutter/Dart extensions)
- Xcode 15+ and CocoaPods, for iOS builds
- A physical device or emulator/simulator with real internet access (speed tests cannot run
  meaningfully on an emulator with no network)

## 5. Installation

```bash
# 1. Unzip / clone the project, then from the project root:
flutter pub get

# 2. (Android only, first time) copy the local.properties template and edit the paths:
cp android/local.properties.example android/local.properties
# then edit android/local.properties and set sdk.dir / flutter.sdk to your machine's paths

# 3. (iOS only) install CocoaPods dependencies:
cd ios && pod install && cd ..
```

If `flutter pub get` reports any Xcode project files as missing (some IDEs expect a fully
generated `ios/Runner.xcodeproj`), run `flutter create .` once from the project root — this is
safe and idempotent: it only fills in missing platform scaffolding and will not overwrite the
Dart source, `pubspec.yaml`, `AndroidManifest.xml`, or `Info.plist` already provided here.

## 6. Running on Android

```bash
flutter devices          # confirm a device/emulator is attached
flutter run -d <deviceId>
```

## 7. Running on iOS

```bash
open ios/Runner.xcworkspace   # optional, to select a signing team in Xcode
flutter run -d <deviceId>
```

## 8. Building an APK

```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

For a smaller, Play Store-ready bundle:

```bash
flutter build appbundle --release
```

> Note: `android/app/build.gradle` currently signs release builds with the **debug** key so
> `flutter build apk --release` works out of the box. Before publishing, add your own keystore
> and signing config in `android/app/build.gradle`.

## 9. Building an iOS release

```bash
flutter build ios --release
# then archive/export via Xcode (Product > Archive) using your own signing team.
```

## 10. Changing the speed-test server / engine

`flutter_internet_speed_test_pro` tests against Fast.com's infrastructure and auto-selects the
best available endpoint — there is no manual server list to edit. If you want to point at a
different provider or self-hosted test backend in the future:

1. Open `lib/features/speed_test/data/repositories/speed_test_repository_impl.dart`.
2. Replace the `FlutterInternetSpeedTest` calls with calls to your new engine/SDK.
3. Keep the same method signatures defined in `SpeedTestRepository` — nothing else in the app
   needs to change, because every screen and provider depends only on that abstract interface.

## 11. Changing app configuration

- **Quality thresholds** (what counts as Excellent/Good/Fair/Poor for ping, download, upload):
  edit `lib/core/constants/quality_thresholds.dart`.
- **General constants** (ping host, timeouts, max history size, chart length): edit
  `lib/core/constants/app_constants.dart`.
- **Colors/theme**: edit `lib/app/theme/app_theme.dart` (Material 3 `ColorScheme.fromSeed`).
- **Text / translations**: edit `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb` — Flutter
  regenerates `AppLocalizations` automatically on the next `flutter pub get` / build (via
  `generate: true` in `pubspec.yaml`), no manual step required.

## 12. Permissions

Only the minimum required permissions are requested:

- **Android**: `INTERNET`, `ACCESS_NETWORK_STATE`, `ACCESS_WIFI_STATE`. No location, contacts,
  camera, microphone, or storage permissions are requested anywhere in the app.
- **iOS**: no location/contacts/camera/microphone/photo-library usage descriptions are declared.
  A `NSLocalNetworkUsageDescription` is included because iOS may show a one-time system prompt
  the first time the app pings a host on the local network path.

## 13. Privacy

NetSpeed does not collect your name, email, phone number, precise location, or contacts, and
includes no analytics/tracking SDKs. All test history is stored **only on your device** via
Hive and is never uploaded anywhere. See the in-app **Settings → Privacy** screen for the same
statement shown to end users.

## 14. Tests

```bash
flutter test
```

Included tests cover:

- Speed unit conversion (Mbps ↔ MB/s)
- Ping / Download / Upload quality classification
- History storage (add / list ordering / clear) via an in-memory Hive box
- Speed test connection & error state transitions (`SpeedTestState.isRunning`, error payloads)
- Widget tests for the speed gauge and quality badge (including localization)

## 15. Project status

This is a complete, runnable Flutter project — not a skeleton. Every file listed under `lib/`
contains full, working implementation code with null safety, error handling, and resource
cleanup (streams, timers, and HTTP/ping sessions are cancelled on `cancelTest()` and on
provider disposal to avoid memory leaks).
