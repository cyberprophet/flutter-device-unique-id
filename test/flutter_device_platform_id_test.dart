import 'package:flutter_device_platform_id/flutter_device_platform_id.dart';
import 'package:flutter_device_platform_id/flutter_device_platform_id_method_channel.dart';
import 'package:flutter_device_platform_id/flutter_device_platform_id_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDevicePlatform
    with MockPlatformInterfaceMixin
    implements FlutterDevicePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getUniqueId() => Future.value('device_unique_id');
}

void main() {
  final FlutterDevicePlatform initialPlatform = FlutterDevicePlatform.instance;

  test('$MethodChannelFlutterDevice is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterDevice>());
  });

  test('getPlatformVersion', () async {
    FlutterDevicePlatformId flutterDeviceUniqueIdPlugin = FlutterDevicePlatformId();
    MockFlutterDevicePlatform fakePlatform = MockFlutterDevicePlatform();
    FlutterDevicePlatform.instance = fakePlatform;

    expect(await flutterDeviceUniqueIdPlugin.getPlatformVersion(), '42');
  });

  test('getUniqueId delegates to FlutterDevicePlatform.instance.getUniqueId()',
      () async {
    FlutterDevicePlatformId flutterDeviceUniqueIdPlugin = FlutterDevicePlatformId();
    MockFlutterDevicePlatform fakePlatform = MockFlutterDevicePlatform();
    FlutterDevicePlatform.instance = fakePlatform;

    expect(await flutterDeviceUniqueIdPlugin.getUniqueId(),
        'device_unique_id');
  });
}
