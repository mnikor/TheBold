//
//  SettingsSectionModel.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class SettingsSectionModel: NSObject {
    
    //MARK: props
    
    var items: [SettingsModel]!
    var header: String?
    
    //MARK: init
    
    init(header: String?, items: [SettingsModel]) {
        self.header = header
        self.items = items
    }
}
