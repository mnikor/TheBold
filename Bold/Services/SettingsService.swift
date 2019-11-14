//
//  CurrentUserService.swift
//  Bold
//
//  Created by Admin on 07.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class SettingsService {
    static var shared = SettingsService()
    
    var syncWithIOSCalendar: Bool {
        didSet {
            if syncWithIOSCalendar != oldValue {
                UserDefaults.standard.set(syncWithIOSCalendar, forKey: DefaultsKeys.syncWithIOSCalendar)
            }
        }
    }
    var syncWithICloud: Bool {
        didSet {
            if syncWithICloud != oldValue {
                UserDefaults.standard.set(syncWithICloud, forKey: DefaultsKeys.syncWithICloud)
            }
        }
    }
    var downloadOnWiFiOnly: Bool {
        didSet {
            if downloadOnWiFiOnly != oldValue {
                UserDefaults.standard.set(downloadOnWiFiOnly, forKey: DefaultsKeys.downloadOnWiFiOnly)
            }
        }
    }
    
    private init() {
        self.syncWithIOSCalendar = UserDefaults.standard.bool(forKey: DefaultsKeys.syncWithIOSCalendar)
        self.syncWithICloud = UserDefaults.standard.bool(forKey: DefaultsKeys.syncWithICloud)
        self.downloadOnWiFiOnly = UserDefaults.standard.bool(forKey: DefaultsKeys.downloadOnWiFiOnly)
    }
    
}

private struct DefaultsKeys {
    static let syncWithIOSCalendar = "syncWithIOSCalendar"
    static let syncWithICloud = "syncWithICloud"
    static let downloadOnWiFiOnly = "downloadOnWiFiOnly"
}
