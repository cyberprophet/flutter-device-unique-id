import 'flutter_device_platform_id_platform_interface.dart';

class FlutterDevicePlatformId {
  Future<String?> getPlatformVersion() {
    return FlutterDevicePlatform.instance.getPlatformVersion();
  }

  Future<String?> getUniqueId() {
    return FlutterDevicePlatform.instance.getUniqueId();
  }
}
