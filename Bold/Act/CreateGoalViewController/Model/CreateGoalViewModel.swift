//
//  CreateGoalViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

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
