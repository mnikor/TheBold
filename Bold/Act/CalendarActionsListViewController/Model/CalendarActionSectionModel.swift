//
//  CalendarActionSectionModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CalendarActionSectionModel: NSObject, Comparable {
    
    var section: CalendarActionSectionViewModel
    var items: [CalendarModelType]
    
    init(section: CalendarActionSectionViewModel, items: [CalendarModelType]) {
        self.section = section
        self.items = items
    }
    
    static func < (lhs: CalendarActionSectionModel, rhs: CalendarActionSectionModel) -> Bool {
        return lhs.section.date < rhs.section.date
    }
}
