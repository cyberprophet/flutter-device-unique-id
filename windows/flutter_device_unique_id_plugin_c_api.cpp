#include "include/flutter_device_unique_id/flutter_device_unique_id_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_device_unique_id_plugin.h"

void FlutterDeviceUniqueIdPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_device_unique_id::FlutterDeviceUniqueIdPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
