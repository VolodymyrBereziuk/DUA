//
//  KeychainWrapper.swift
//  Technopark17
//
//  Created by Viktor Drykin on 05.09.17.
//  Copyright © 2017 Ruvents. All rights reserved.
//

import Foundation
import KeychainAccess

struct KeychainWrapper {
    
    let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "Dostupno.ua")
    let kAppToken = "AppToken"
    
    func saveToken(token: DostupnoToken?) {
        keychain.set(encodable: token, forKey: kAppToken)
    }
    
    func getToken() -> DostupnoToken? {
        return keychain.value(DostupnoToken.self, forKey: kAppToken)
    }
    
    func removeToken() {
        do {
            try keychain.remove(kAppToken)
        } catch {
            print(error)
        }
    }
    
    func removeAll() {
        do {
            try keychain.removeAll()
        } catch {
            print(error)
        }
    }
}

extension Keychain {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            do {
                try set(data, key: key)
            } catch {
                print(error)
            }
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = try? getData(key), let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
