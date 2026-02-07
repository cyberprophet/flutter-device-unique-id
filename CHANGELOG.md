## 1.0.1 - 2026-02-07

### Fixed
- Android debug build compatibility with current Flutter Gradle plugin APIs
- Removed duplicate legacy Groovy Gradle files in `example/android` to avoid mixed DSL/version conflicts

### Changed
- Updated Android toolchain alignment for this repo:
  - Plugin Android build uses AGP `8.11.1`, Kotlin `2.2.20`, Java `17`, compileSdk `36`, minSdk `24`
  - Example Android Gradle wrapper uses `8.14`

## 1.0.0 - 2026-02-07

### Added
- ✨ **macOS platform support** with Keychain storage
- ✨ **Windows platform support** with HKCU registry storage  
- ✨ **Web platform support** with localStorage fallback chain (localStorage → sessionStorage → in-memory)
- 🧪 Comprehensive integration tests for all platforms with platform-specific format validation
- 🧪 Expanded unit tests for API delegation and method channel wiring
- 📚 Detailed platform-specific documentation in README

### Changed
- Package name changed to `flutter_device_platform_id`
- Minimum Dart SDK: `>=3.5.0`
- Minimum Flutter SDK: `>=3.24.0`
- 📦 Added `flutter_web_plugins` SDK dependency
- 📦 Added `web: ^1.0.0` dependency for modern web APIs

### Implementation Details
- **macOS**: Uses Security framework (SecItem* APIs) for Keychain access, requires keychain-access-groups entitlement
- **Windows**: Uses Windows Registry API (RegOpenKeyEx, RegSetValueEx) with HKCU for per-user storage
- **Web**: Uses `package:web` for modern Dart web APIs, graceful fallback for private browsing mode
