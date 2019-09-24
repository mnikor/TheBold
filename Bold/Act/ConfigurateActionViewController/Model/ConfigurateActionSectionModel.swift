//
//  ConfigurateActionSectionModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ConfigurateActionSectionModel: NSObject {
    
    var type: ConfigureActionType.HeaderType
    var items: [ConfigurateActionCellModel]
    
    init(type:ConfigureActionType.HeaderType, items: [ConfigurateActionCellModel]) {
        
        self.type = type
        self.items = items
    }
}
