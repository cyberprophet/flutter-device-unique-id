// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_device_unique_id/flutter_device_unique_id.dart';

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
}
