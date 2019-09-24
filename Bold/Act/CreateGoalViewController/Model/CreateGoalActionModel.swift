//
//  CreateGoalModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum CreateCellModelType {
    case header(HeaderCreateType, String?)
    case date(String)
    case color(ColorGoalType)
    case icon(IdeasType)
    case value(String?)
    case colors([ColorGoalType], ColorGoalType)
    case icons([IdeasType], IdeasType, ColorGoalType)
    case none
}

class CreateGoalActionModel: NSObject {

    var type: AddActionCellType
    var modelValue: CreateCellModelType
    
    init(type: AddActionCellType, modelValue: CreateCellModelType) {
        self.type = type
        self.modelValue = modelValue
    }
}
