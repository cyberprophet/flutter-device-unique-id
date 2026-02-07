import Cocoa
import FlutterMacOS
import Security

public class FlutterDevicePlatformIdPlugin: NSObject, FlutterPlugin {
  private static let keychainService = "com.shareinvest.unique_id"
  private static let keychainAccount = "uniqueDeviceId"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_device_platform_id", binaryMessenger: registrar.messenger)
    let instance = FlutterDevicePlatformIdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "getUniqueId":
      result(getUniqueId())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getUniqueId() -> String? {
    // Try to retrieve existing UUID from Keychain
    if let existingId = retrieveFromKeychain() {
      print("Retrieved existing Device ID from Keychain: \(existingId)")
      return existingId
    }

    // Generate new UUID and store in Keychain
    let newUUID = UUID().uuidString
    if storeInKeychain(newUUID) {
      print("Stored new Device ID in Keychain: \(newUUID)")
      return newUUID
    } else {
      print("Failed to store Device ID in Keychain, returning nil")
      return nil
    }
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

    if status == errSecSuccess, let data = result as? Data {
      if let string = String(data: data, encoding: .utf8) {
        return string
      }
    } else if status != errSecItemNotFound {
      print("Keychain retrieval error: \(status)")
    }

    return nil
  }

  private func storeInKeychain(_ value: String) -> Bool {
    guard let data = value.data(using: .utf8) else {
      print("Failed to encode UUID as UTF-8")
      return false
    }

    let attributes: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Self.keychainService,
      kSecAttrAccount as String: Self.keychainAccount,
      kSecValueData as String: data
    ]

    let status = SecItemAdd(attributes as CFDictionary, nil)

    if status == errSecSuccess {
      return true
    } else if status == errSecDuplicateItem {
      // Item already exists, try to update it
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: Self.keychainService,
        kSecAttrAccount as String: Self.keychainAccount
      ]

      let updateAttributes: [String: Any] = [
        kSecValueData as String: data
      ]

      let updateStatus = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)
      if updateStatus == errSecSuccess {
        return true
      } else {
        print("Keychain update error: \(updateStatus)")
        return false
      }
    } else {
      print("Keychain storage error: \(status)")
      return false
    }
  }
}
