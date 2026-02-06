# Flutter Device Unique ID

A Flutter plugin for getting a unique device identifier across multiple platforms.

## Supported Platforms

| Platform | Identifier Source | Persistence | Reset Conditions |
|----------|------------------|-------------|------------------|
| Android | `Settings.Secure.ANDROID_ID` | System | Factory reset, signing key change |
| iOS | Keychain stored UUID | Keychain | Keychain cleared, app reinstall |
| macOS | Keychain stored UUID | Keychain (per-user) | Keychain cleared |
| Windows | Registry stored UUID | HKCU Registry (per-user) | Profile reset, registry cleared |
| Web | localStorage stored UUID | Browser storage | Site data cleared, incognito mode |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_device_unique_id: ^2.0.0
```

## Usage

```dart
import 'package:flutter_device_unique_id/flutter_device_unique_id.dart';

// Get the unique device ID
String? uniqueId = await FlutterDeviceUniqueId().getUniqueId();

// Get the platform version
String? platformVersion = await FlutterDeviceUniqueId().getPlatformVersion();
```

## Platform-Specific Details

### Android
- **Source**: `Settings.Secure.ANDROID_ID`
- **Format**: 16+ character hexadecimal string
- **Persistence**: Survives app reinstalls
- **Reset**: Factory reset or signing key change

### iOS
- **Source**: UUID stored in Keychain via KeychainAccess library
- **Format**: UUID (8-4-4-4-12)
- **Storage**: Keychain service `com.shareinvest.unique_id`, account `uniqueDeviceId`
- **Persistence**: Survives app reinstalls
- **Reset**: Keychain cleared or device restore

### macOS
- **Source**: UUID stored in macOS Keychain
- **Format**: UUID (8-4-4-4-12)
- **Storage**: Keychain service `com.shareinvest.unique_id`, account `uniqueDeviceId`
- **Persistence**: Per-user, survives app reinstalls
- **Reset**: Keychain cleared
- **Requirements**: Keychain entitlements for sandboxed apps

### Windows
- **Source**: UUID stored in Windows Registry
- **Format**: UUID (8-4-4-4-12)
- **Storage**: `HKEY_CURRENT_USER\Software\com.shareinvest\flutter_device_unique_id` value `uniqueDeviceId`
- **Persistence**: Per-user, survives app reinstalls
- **Reset**: Registry cleared or user profile reset

### Web
- **Source**: UUID stored in browser localStorage
- **Format**: UUID (8-4-4-4-12)
- **Storage**: localStorage key `flutter_device_unique_id.uniqueDeviceId`
- **Fallback**: sessionStorage → in-memory (for private browsing)
- **Persistence**: Browser-profile scoped
- **Reset**: Site data cleared, incognito/private mode
- **Note**: Does NOT use fingerprinting, MAC addresses, or IP addresses

## Privacy & Compliance

**Important**: This plugin provides a device-scoped identifier, NOT an advertising identifier.

- ✅ **Intended use**: Correlate a single device/browser-profile across multiple login providers
- ❌ **NOT for**: Cross-app tracking, advertising, analytics across different apps/sites
- 🔒 **Privacy**: No fingerprinting, no MAC addresses, no IP addresses (Web)
- 📱 **Scope**: App-scoped (mobile/desktop), browser-profile scoped (web)

## Requirements

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter SDK: `>=3.24.0`

## Example

See the [example](example/) directory for a complete sample app demonstrating usage on all platforms.

## License

See [LICENSE](LICENSE) file.

## Maintainer

ShareInvest Corp.