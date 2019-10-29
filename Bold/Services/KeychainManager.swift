//
//  KeychainManager.swift
//  Bold
//
//  Created by Admin on 10/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainManager {
    
    // MARK: - Public
    
    static let keychain = Keychain(service: Constants.keychainName)
}

// MARK: - Constants

private struct Constants {
    static let keychainName = "BuduSushi"
}
