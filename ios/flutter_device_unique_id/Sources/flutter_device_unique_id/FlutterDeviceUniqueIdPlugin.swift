import Flutter
import UIKit
import Security

public class FlutterDeviceUniqueIdPlugin: NSObject, FlutterPlugin {
  private static let keychainService = "com.shareinvest.unique_id"
  private static let keychainAccount = "uniqueDeviceId"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_device_unique_id", binaryMessenger: registrar.messenger())
    let instance = FlutterDeviceUniqueIdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getUniqueId":
      result(getUniqueId())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getUniqueId() -> String {
    if let existingId = retrieveFromKeychain() {
      return existingId
    }

    let newUUID = UUID().uuidString
    _ = storeInKeychain(newUUID)
    return newUUID
  }

  private func retrieveFromKeychain() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Self.keychainService,
      kSecAttrAccount as String: Self.keychainAccount,
      kSecReturnData as String: true
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess,
          let data = result as? Data,
          let value = String(data: data, encoding: .utf8),
          !value.isEmpty else {
      return nil
    }

    return value
  }

  private func storeInKeychain(_ value: String) -> Bool {
    guard let data = value.data(using: .utf8) else {
      return false
    }

    let addQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Self.keychainService,
      kSecAttrAccount as String: Self.keychainAccount,
      kSecValueData as String: data
    ]

    let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
    if addStatus == errSecSuccess {
      return true
    }

    if addStatus == errSecDuplicateItem {
      let updateQuery: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: Self.keychainService,
        kSecAttrAccount as String: Self.keychainAccount
      ]

      let updateData: [String: Any] = [
        kSecValueData as String: data
      ]

      return SecItemUpdate(updateQuery as CFDictionary, updateData as CFDictionary) == errSecSuccess
    }

    return false
  }
}
