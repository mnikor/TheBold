//
//  LevelBold.swift
//  Bold
//
//  Created by Alexander Kovalov on 04.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

// MARK: Status Levels Type
enum StatusLevelsType: String {
    case active, disable, progress
}

class LevelBold {
    
    
    // MARK: - Public Properties
    let type: LevelType
    var status: StatusLevelsType
    let limits: [LimitsLevel]
    
    var isCurrentLevel: Bool = false
    
    
    private var percent: Int?
    var completionPercentage: Int {
        //for completionPercentage
        get {
            let currentLimit = LevelOfMasteryService.shared.currentLimit!
            let limit = limits.first!
            
            let limitItems: [Int] = [limit.points, limit.goalMid, limit.goalLong]
            let currentItems: [Int] = [currentLimit.points, currentLimit.goalMid, currentLimit.goalLong]
            
            var count: Int = 0
            var sum: Int = 0
            
            for item in limitItems {
                if item != 0 {
                    
                    // Compute percent for each limits and add to sum
                    sum += computePercent(currentItems[count], item)
                    count += 1
                }
            }
            
            // Average percent all limits or 0
            return count == 0 ? 0 : sum / count
        }
        set(value) {
            percent = value
        }
    }

    
    // MARK: - Initializers
    init(type: LevelType) {
        
        self.type = type
        self.status = LevelType.apprentice == type ? .active : .disable
        limits = type.limits
    }
    
    
    // MARK: - Private funcs
    private func computePercent(_ this: Int, _ need: Int) -> Int {
        
        guard need != 0 else { return 100 }
        if self.percent != nil {
            return self.percent!
        }
        var percent: Int = (100 * this) / need
        percent = percent > 100 ? 100 : percent
        
        return percent
    }
}
