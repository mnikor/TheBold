//
//  SessionManager.swift
//  Bold
//
//  Created by Admin on 10/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import KeychainAccess

class SessionManager {
    
    // MARK: - Public variables
    
    static let shared = SessionManager()
    
    private(set) var token = KeychainManager.keychain[Constants.tokenKey]
    private(set) var apiToken = KeychainManager.keychain[Constants.apiTokenKey]
    private var tokenExpireDate: Date {
        let expireDateString = KeychainManager.keychain[Constants.expireDate] ?? ""
        let timeInterval = Double(expireDateString) ?? 0
        return Date(timeIntervalSince1970: timeInterval)
    }
//    private var tokenExpireDate = Date(timeIntervalSince1970: Double((KeychainManager.keychain[Constants.expireDate]))
    private var timer: Timer?
    
    var profile: Profile? {
        didSet {
            NotificationCenter.default.post(name: .profileChanged, object: nil, userInfo: nil)
        }
    }
    
    // MARK: - Life cycle
    private init() {
        if tokenExpireDate < Date() {
            killSession()
        } else {
            configTimer()
        }
    }
    
    // MARK: - Public
    
    func killSession() {
        setToken(nil)
        profile = nil
        timer?.invalidate()
    }
    
    func updateToken(_ newToken: String, expireDate: Date) {
        let timeInterval = expireDate.timeIntervalSince1970
        setExpireDate(timeInterval)
        setToken(newToken)
        configTimer()
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
    
    private func setExpireDate(_ timeIntervalSince1970: TimeInterval) {
//        tokenExpireDate = Date(timeIntervalSince1970: timeIntervalSince1970)
        KeychainManager.keychain[Constants.expireDate] = String(timeIntervalSince1970)
    }
    
    private func configTimer() {
        let timeIntervalSinceNow = tokenExpireDate.timeIntervalSinceNow
        timer = Timer.scheduledTimer(withTimeInterval: timeIntervalSinceNow, repeats: false) { [weak self] _ in
            self?.tokenExpired()
        }
    }
    
    private func tokenExpired() {
        killSession()
        guard let viewController = StoryboardScene.Splash.storyboard.instantiateInitialViewController()
            else { return }
        UIApplication.setRootView(viewController,
                                  animated: true)
    }
}

// MARK: - Constants

private struct Constants {
    static let tokenKey = "Token"
    static let apiTokenKey = "Api-Token"
    static let expireDate = "token expiration date"
}
