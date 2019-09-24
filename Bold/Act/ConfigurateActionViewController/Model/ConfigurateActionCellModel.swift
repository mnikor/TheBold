//
//  ConfigurateActionCellModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ConfigurateActionCellModel: NSObject {
    
    var type: ConfigureActionType
    var modelValue: ConfigureActionModelType
    
    init(type: ConfigureActionType, modelValue: ConfigureActionModelType) {
        self.type = type
        self.modelValue = modelValue
    }
}

enum ConfigureActionModelType {
    case header(String)
    case body(title: String, value: String?, accessory:Bool, isSelected:Bool, textColor:Color)
    case daysOfWeek([DaysOfWeekType])
    case createNewGoal(placeholder: String)
    case none
}

struct GoalNameAndId {
    let type: ConfigureActionType.BodyType
    let goal: Goal?
}
