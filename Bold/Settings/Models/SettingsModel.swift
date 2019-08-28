//
//  SettingsModel.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum SettingsAccessoryType {
    case arrow
    case toggle
    case none
}

enum SettingsCellType: String {
    case premium
    case iosCalendar = "iOSCalendar"
    case googleCalendar = "googleCalendar"
    case iCloud = "saveOniCloud"
    case onWifi = "useWiFiForContent"
    case terms
    case privacy
    case version
    case signOut
}

class SettingsModel: NSObject {
    
    //MARK: props
    
    var title: String?
    var accessoryType: SettingsAccessoryType
    var cellType: SettingsCellType
    var toggleInitialValue: Bool
    
    
    //MARK: init
    
    init(title: String?, accessoryType: SettingsAccessoryType = .none, toggleInitialValue: Bool = false, cellType: SettingsCellType) {
        self.title = title
        self.cellType = cellType
        self.accessoryType = accessoryType
        self.toggleInitialValue = toggleInitialValue
    }
}
