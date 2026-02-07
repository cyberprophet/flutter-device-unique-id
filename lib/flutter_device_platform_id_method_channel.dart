import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_device_platform_id_platform_interface.dart';

class MethodChannelFlutterDevice extends FlutterDevicePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_device_platform_id');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getUniqueId() async {
    return await methodChannel.invokeMethod<String?>('getUniqueId');
  }
}
