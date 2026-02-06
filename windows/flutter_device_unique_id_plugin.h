#ifndef FLUTTER_PLUGIN_FLUTTER_DEVICE_UNIQUE_ID_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_DEVICE_UNIQUE_ID_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_device_unique_id {

class FlutterDeviceUniqueIdPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterDeviceUniqueIdPlugin();

  virtual ~FlutterDeviceUniqueIdPlugin();

  // Disallow copy and assign.
  FlutterDeviceUniqueIdPlugin(const FlutterDeviceUniqueIdPlugin&) = delete;
  FlutterDeviceUniqueIdPlugin& operator=(const FlutterDeviceUniqueIdPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_device_unique_id

#endif  // FLUTTER_PLUGIN_FLUTTER_DEVICE_UNIQUE_ID_PLUGIN_H_
