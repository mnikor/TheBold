//
//  CreateGoalModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum CreateGoalModelType {
    case header(HeaderCreateType, String?)
    case date(String)
    case color(ColorGoalType)
    case icon(IdeasType)
    case value(String?)
    case colors([ColorGoalType], ColorGoalType)
    case icons([IdeasType], IdeasType, ColorGoalType)
}

class CreateGoalModel: NSObject {

    var type: AddActionCellType
    var modelValue: CreateGoalModelType
    
    init(type: AddActionCellType, modelValue: CreateGoalModelType) {
        self.type = type
        self.modelValue = modelValue
    }
}

struct CreateGoalViewModel {
    let startDate : Date
    let startDateString : String
    let endDate : Date
    let endDateString : String
    let color : ColorGoalType
    let icon : IdeasType
    let nameGoal : String?
    let colors : [ColorGoalType]
    let icons : [IdeasType]
}
