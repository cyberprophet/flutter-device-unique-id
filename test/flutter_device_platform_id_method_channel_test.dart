import 'package:flutter/services.dart';
import 'package:flutter_device_platform_id/flutter_device_platform_id_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterDevice platform = MethodChannelFlutterDevice();
  const MethodChannel channel = MethodChannel('flutter_device_platform_id');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlatformVersion':
            return '42';
          case 'getUniqueId':
            return 'device_unique_id';
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('getUniqueId invokes method channel with correct method name',
      () async {
    expect(await platform.getUniqueId(), 'device_unique_id');
  });
}
