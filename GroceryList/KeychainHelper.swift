//
//  KeychainHelper.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 5/9/25.
//

import Security
import Foundation

class KeychainHelper {
    // Use static to make it callable without creating an instance
    static func save(_ data: String, forKey key: String) {
        if let data = data.data(using: .utf8) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data
            ] as CFDictionary

            SecItemDelete(query)  // Delete any existing data for the key
            SecItemAdd(query, nil)  // Add the new data to the keychain
        }
    }

    static func read(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
