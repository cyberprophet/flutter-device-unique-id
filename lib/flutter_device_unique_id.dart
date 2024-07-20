import 'flutter_device_unique_id_platform_interface.dart';

class FlutterDeviceUniqueId {
  Future<String?> getPlatformVersion() {
    return FlutterDevicePlatform.instance.getPlatformVersion();
  }

  Future<String?> getUniqueId() {
    return FlutterDevicePlatform.instance.getUniqueId();
  }
}
