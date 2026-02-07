#include "flutter_device_platform_id_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>
#include <objbase.h>
#include <string>

namespace flutter_device_platform_id {

// static
void FlutterDevicePlatformIdPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter_device_platform_id",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FlutterDevicePlatformIdPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

FlutterDevicePlatformIdPlugin::FlutterDevicePlatformIdPlugin() {}

FlutterDevicePlatformIdPlugin::~FlutterDevicePlatformIdPlugin() {}

void FlutterDevicePlatformIdPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if (method_call.method_name().compare("getUniqueId") == 0) {
    std::string unique_id = GetOrCreateUniqueId();
    if (!unique_id.empty()) {
      result->Success(flutter::EncodableValue(unique_id));
    } else {
      result->Error("REGISTRY_ERROR", "Failed to get or create unique ID");
    }
  } else {
    result->NotImplemented();
  }
}

std::string FlutterDevicePlatformIdPlugin::GenerateUUID() {
  GUID guid;
  if (CoCreateGuid(&guid) != S_OK) {
    return "";
  }

  char uuid_str[37];
  snprintf(uuid_str, sizeof(uuid_str),
           "%08lX-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X",
           guid.Data1, guid.Data2, guid.Data3,
           guid.Data4[0], guid.Data4[1], guid.Data4[2], guid.Data4[3],
           guid.Data4[4], guid.Data4[5], guid.Data4[6], guid.Data4[7]);

  return std::string(uuid_str);
}

std::string FlutterDevicePlatformIdPlugin::GetUniqueIdFromRegistry() {
  HKEY hkey = nullptr;
  const wchar_t* subkey = L"Software\\com.shareinvest\\flutter_device_platform_id";
  const wchar_t* value_name = L"uniqueDeviceId";

  if (RegOpenKeyExW(HKEY_CURRENT_USER, subkey, 0, KEY_READ, &hkey) != ERROR_SUCCESS) {
    return "";
  }

  wchar_t value[256] = {0};
  DWORD value_size = sizeof(value);
  DWORD value_type = 0;

  LONG result = RegQueryValueExW(hkey, value_name, nullptr, &value_type, 
                                  reinterpret_cast<LPBYTE>(value), &value_size);
  RegCloseKey(hkey);

  if (result != ERROR_SUCCESS || value_type != REG_SZ) {
    return "";
  }

  int size_needed = WideCharToMultiByte(CP_UTF8, 0, value, -1, nullptr, 0, nullptr, nullptr);
  std::string str(size_needed - 1, 0);
  WideCharToMultiByte(CP_UTF8, 0, value, -1, &str[0], size_needed, nullptr, nullptr);

  return str;
}

bool FlutterDevicePlatformIdPlugin::SetUniqueIdInRegistry(const std::string& unique_id) {
  HKEY hkey = nullptr;
  const wchar_t* subkey = L"Software\\com.shareinvest\\flutter_device_platform_id";
  const wchar_t* value_name = L"uniqueDeviceId";

  DWORD disposition = 0;
  if (RegCreateKeyExW(HKEY_CURRENT_USER, subkey, 0, nullptr, REG_OPTION_NON_VOLATILE,
                      KEY_WRITE, nullptr, &hkey, &disposition) != ERROR_SUCCESS) {
    return false;
  }

  int size_needed = MultiByteToWideChar(CP_UTF8, 0, unique_id.c_str(), -1, nullptr, 0);
  std::wstring wide_id(size_needed - 1, 0);
  MultiByteToWideChar(CP_UTF8, 0, unique_id.c_str(), -1, &wide_id[0], size_needed);

  LONG result = RegSetValueExW(hkey, value_name, 0, REG_SZ,
                               reinterpret_cast<const BYTE*>(wide_id.c_str()),
                               (wide_id.length() + 1) * sizeof(wchar_t));
  RegCloseKey(hkey);

  return result == ERROR_SUCCESS;
}

std::string FlutterDevicePlatformIdPlugin::GetOrCreateUniqueId() {
  std::string unique_id = GetUniqueIdFromRegistry();
  if (!unique_id.empty()) {
    return unique_id;
  }

  unique_id = GenerateUUID();
  if (unique_id.empty()) {
    return "";
  }

  if (!SetUniqueIdInRegistry(unique_id)) {
    return "";
  }

  return unique_id;
}

}  // namespace flutter_device_platform_id
