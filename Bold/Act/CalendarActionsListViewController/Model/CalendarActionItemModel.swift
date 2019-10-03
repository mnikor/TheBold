//
//  CalendarActionItemModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ActCellType {
    case goals
    case calendar
    case stake
}

enum CalendarModelType {
    case calendar(dates: Set<Date>)
    case event(viewModel: StakeActionViewModel)
}

class CalendarActionItemModel: NSObject {

    let type: ActCellType
    let modelView: CalendarModelType
    
    init(type: ActCellType, modelView: CalendarModelType) {
        self.type = type
        self.modelView = modelView
    }
}
