import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_device_platform_id_method_channel.dart';

abstract class FlutterDevicePlatform extends PlatformInterface {
  FlutterDevicePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDevicePlatform _instance = MethodChannelFlutterDevice();

  static FlutterDevicePlatform get instance => _instance;

  static set instance(FlutterDevicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getUniqueId() {
    throw UnimplementedError('getUniqueId() has not been implemented.');
  }
}
