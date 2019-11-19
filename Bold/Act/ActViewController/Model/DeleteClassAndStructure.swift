//
//  DeleteClassAndStructure.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

struct ActEntity {
    var type: ActCellType
    var items: Array<Any>?
    var selected: Bool
}

class CalendarEntity {
    var headerType: ActHeaderType
    var items: Array<ActEntity>

    init(headerType: ActHeaderType, items: Array<ActEntity>) {
        self.headerType = headerType
        self.items = items
    }
}

enum ActCellType {
    case goals
    case calendar
    case stake
}

//class CalendarActionItemModel: NSObject {
//
//    let type: ActCellType
//    let viewModel: CalendarModelType
//
//    init(type: ActCellType, modelView: CalendarModelType) {
//        self.type = type
//        self.viewModel = modelView
//    }
//}
