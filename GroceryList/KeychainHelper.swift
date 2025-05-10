//
//  KeychainHelper.swift
//  GroceryList
//
//  Created by Brandon Jacobs on 5/9/25.
//
import Foundation
import Security

class KeychainHelper {
    static func saveAccounts(_ accounts: [UserAccount]) {
        if let data = try? JSONEncoder().encode(accounts) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: "userAccounts",
                kSecValueData: data
            ] as CFDictionary

            SecItemDelete(query)
            SecItemAdd(query, nil)
        }
    }

    static func loadAccounts() -> [UserAccount] {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "userAccounts",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            if let accounts = try? JSONDecoder().decode([UserAccount].self, from: data) {
                return accounts
            }
        }
        return []
    }
}
