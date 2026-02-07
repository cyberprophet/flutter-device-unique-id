#include "include/flutter_device_platform_id/flutter_device_platform_id_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_device_platform_id_plugin.h"

void FlutterDevicePlatformIdPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_device_platform_id::FlutterDevicePlatformIdPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
