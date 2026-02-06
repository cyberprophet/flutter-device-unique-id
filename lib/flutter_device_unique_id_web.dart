// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'flutter_device_unique_id_platform_interface.dart';

/// A web implementation of the FlutterDevicePlatform of the FlutterDeviceUniqueId plugin.
class FlutterDeviceUniqueIdWeb extends FlutterDevicePlatform {
  /// Constructs a FlutterDeviceUniqueIdWeb
  FlutterDeviceUniqueIdWeb();

  static void registerWith(Registrar registrar) {
    FlutterDevicePlatform.instance = FlutterDeviceUniqueIdWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  /// Returns a [String] containing the unique ID for the device.
  @override
  Future<String?> getUniqueId() async {
    // Web implementation - return a default value for now
    // This will be properly implemented in Task 3
    return null;
  }
}
