//
//  TempStructures.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

struct GoalEntity {
    var type: GoalType
    var active: GoalCellType
    var progress: Int
    var total: Int
}

enum GoalCellType {
    case active
    case locked
    case completed
    case failed
}
