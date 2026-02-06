// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_device_unique_id/flutter_device_unique_id.dart';

// Platform-specific format validators
bool _isValidAndroidId(String id) {
  // Android: 16+ hex characters (ANDROID_ID format)
  return id.length >= 16 && RegExp(r'^[0-9a-fA-F]+$').hasMatch(id);
}

bool _isValidUUID(String id) {
  // UUID format: 8-4-4-4-12 hex characters with hyphens
  // Example: 550e8400-e29b-41d4-a716-446655440000
  return RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
      .hasMatch(id);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final FlutterDeviceUniqueId plugin = FlutterDeviceUniqueId();
    final String? version = await plugin.getPlatformVersion();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version?.isNotEmpty, true);
  });

  testWidgets('getUniqueId returns non-empty string', (WidgetTester tester) async {
    final FlutterDeviceUniqueId plugin = FlutterDeviceUniqueId();
    final String? uniqueId = await plugin.getUniqueId();
    expect(uniqueId, isNotNull);
    expect(uniqueId?.isNotEmpty, true);
  });

  testWidgets('getUniqueId is idempotent', (WidgetTester tester) async {
    final FlutterDeviceUniqueId plugin = FlutterDeviceUniqueId();
    final String? firstCall = await plugin.getUniqueId();
    final String? secondCall = await plugin.getUniqueId();
    expect(firstCall, equals(secondCall));
  });

  testWidgets('getUniqueId returns same value across multiple calls', (WidgetTester tester) async {
    final FlutterDeviceUniqueId plugin = FlutterDeviceUniqueId();
    final String? id1 = await plugin.getUniqueId();
    final String? id2 = await plugin.getUniqueId();
    final String? id3 = await plugin.getUniqueId();
    expect(id1, equals(id2));
    expect(id2, equals(id3));
  });

  testWidgets('getUniqueId format validation - platform specific', (WidgetTester tester) async {
    final FlutterDeviceUniqueId plugin = FlutterDeviceUniqueId();
    final String? uniqueId = await plugin.getUniqueId();
    
    expect(uniqueId, isNotNull);
    
    // Platform-specific format validation
    if (Platform.isAndroid) {
      // Android: 16+ hex characters (ANDROID_ID format)
      expect(_isValidAndroidId(uniqueId!), true,
          reason: 'Android ID should be 16+ hex characters, got: $uniqueId');
    } else if (Platform.isIOS || Platform.isMacOS || Platform.isWindows) {
      // iOS/macOS/Windows: UUID format (8-4-4-4-12)
      expect(_isValidUUID(uniqueId!), true,
          reason: 'Expected UUID format (8-4-4-4-12), got: $uniqueId');
    } else if (kIsWeb) {
      // Web: UUID format (8-4-4-4-12)
      expect(_isValidUUID(uniqueId!), true,
          reason: 'Expected UUID format (8-4-4-4-12) on web, got: $uniqueId');
    }
  });

  // Web-specific test: localStorage key verification
  if (kIsWeb) {
    testWidgets('Web: localStorage key is created when available', (WidgetTester tester) async {
      final FlutterDeviceUniqueId plugin = FlutterDeviceUniqueId();
      
      // Call getUniqueId to trigger storage
      final String? uniqueId = await plugin.getUniqueId();
      expect(uniqueId, isNotNull);
      
      // Note: Direct localStorage access from Dart requires web-specific code.
      // This test verifies that getUniqueId completes successfully on web,
      // which indicates the storage fallback chain is working.
      // Full localStorage verification would require a separate web test runner.
      expect(uniqueId?.isNotEmpty, true);
    });
  }
}
