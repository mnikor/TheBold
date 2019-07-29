//
//  Goal.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class Goal: NSObject {
    var name: String?
    var startDate: Date!
    var endDate: Date!
    var color: ColorGoalType!
    var icon: IdeasType!
    
    init(name: String?, startDate: Date, endDate: Date, color: ColorGoalType, icon: IdeasType) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
        self.icon = icon
    }
}
