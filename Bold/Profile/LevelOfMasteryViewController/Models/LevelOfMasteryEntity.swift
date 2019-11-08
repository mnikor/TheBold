//
//  LevelOfMasteryEntity.swift
//  Bold
//
//  Created by Alexander Kovalov on 08.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

struct LevelOfMasteryEntity {
    var type: LevelType
    var isLock: Bool
    var progress: Int
    var params: [CheckLevelEntity]
}

struct CheckLevelEntity {
    var checkPoint: Bool = false
    var titleText: String
    var points: Int?
    var timeDuration: Date?
}
