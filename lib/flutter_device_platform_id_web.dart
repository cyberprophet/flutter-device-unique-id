// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'flutter_device_platform_id_platform_interface.dart';

/// Storage key for persisting the unique device ID
const String _storageKey = 'flutter_device_platform_id.uniqueDeviceId';

/// In-memory fallback storage when browser storage is unavailable
String? _inMemoryId;

/// A web implementation of the FlutterDevicePlatform of the FlutterDevicePlatformId plugin.
class FlutterDevicePlatformIdWeb extends FlutterDevicePlatform {
  /// Constructs a FlutterDevicePlatformIdWeb
  FlutterDevicePlatformIdWeb();

  static void registerWith(Registrar registrar) {
    FlutterDevicePlatform.instance = FlutterDevicePlatformIdWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  /// Returns a [String] containing the unique ID for the device.
  /// Uses storage fallback chain: localStorage -> sessionStorage -> in-memory
  @override
  Future<String?> getUniqueId() async {
    // Try to retrieve from localStorage
    try {
      final stored = web.window.localStorage.getItem(_storageKey);
      if (stored != null && stored.isNotEmpty) {
        return stored;
      }
    } catch (_) {
      // localStorage unavailable, continue to next fallback
    }

    // Try to retrieve from sessionStorage
    try {
      final stored = web.window.sessionStorage.getItem(_storageKey);
      if (stored != null && stored.isNotEmpty) {
        return stored;
      }
    } catch (_) {
      // sessionStorage unavailable, continue to next fallback
    }

    // Check in-memory fallback
    if (_inMemoryId != null && _inMemoryId!.isNotEmpty) {
      return _inMemoryId;
    }

    // Generate new UUID
    final newId = _generateUUID();

    // Try to store in localStorage
    try {
      web.window.localStorage.setItem(_storageKey, newId);
      return newId;
    } catch (_) {
      // localStorage failed, try sessionStorage
    }

    // Try to store in sessionStorage
    try {
      web.window.sessionStorage.setItem(_storageKey, newId);
      return newId;
    } catch (_) {
      // sessionStorage failed, use in-memory fallback
    }

    // Store in in-memory fallback
    _inMemoryId = newId;
    return newId;
  }

  /// Generates a UUID v4 using the Web Crypto API
  String _generateUUID() {
    // Try to use crypto.randomUUID() if available
    try {
      final crypto = web.window.crypto;
      final randomUUID = crypto.randomUUID();
      return randomUUID;
    } catch (_) {
      // Fallback: generate a simple UUID-like string
      return _generateUUIDFallback();
    }
  }

  /// Fallback UUID generation using simple random approach
  String _generateUUIDFallback() {
    const chars = '0123456789abcdef';
    final uuid = StringBuffer();

    for (int i = 0; i < 36; i++) {
      if (i == 8 || i == 13 || i == 18 || i == 23) {
        uuid.write('-');
      } else if (i == 14) {
        uuid.write('4'); // Version 4
      } else {
        final randomIndex = (DateTime.now().microsecond + i) % 16;
        uuid.write(chars[randomIndex]);
      }
    }

    return uuid.toString();
  }
}
