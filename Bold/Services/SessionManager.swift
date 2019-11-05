//
//  SessionManager.swift
//  Bold
//
//  Created by Admin on 10/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import KeychainAccess

class SessionManager {
    
    // MARK: - Public variables
    
    static let shared = SessionManager()
    
    private(set) var token = KeychainManager.keychain[Constants.tokenKey]
    private(set) var apiToken = KeychainManager.keychain[Constants.apiTokenKey]
    
    var profile: Profile? {
        didSet {
            NotificationCenter.default.post(name: .profileChanged, object: nil, userInfo: nil)
        }
    }
    
    // MARK: - Life cycle
    private init() { }
    
    // MARK: - Public
    
    func killSession() {
        setToken(nil)
        profile = nil
    }
    
    func updateToken(_ newToken: String) {
        setToken(newToken)
    }
    
    
    func updateApiToken(_ newToken: String) {
        setApiToken(newToken)
    }
    
    private func setToken(_ newToken: String?) {
        token = newToken
        KeychainManager.keychain[Constants.tokenKey] = newToken
    }
    
    private func setApiToken(_ newToken: String) {
        apiToken = newToken
        KeychainManager.keychain[Constants.apiTokenKey] = newToken
    }
}

// MARK: - Constants

private struct Constants {
    static let tokenKey = "Token"
    static let apiTokenKey = "Api-Token"
}
