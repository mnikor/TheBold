//
//  LevelOfMasteryService.swift
//  Bold
//
//  Created by Alexander Kovalov on 31.10.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum GoalTimeSpentType {
    case short, mid, long
}

struct LevelInfoObserv {
    let level: LevelBold
    let currentPoint: Int
}

enum LevelOfMasteryServiceInput {
    case currentLevel(level: Callback<LevelBold>)
    case getAllLevels(levels: Callback<[LevelBold]>)
    //case currentPoints(points: Callback<(Int)>)
    case addPoints(points: Int)
    case deductPoints(points: Int)
}

protocol LevelOfMasteryServiceProtocol :class {
    func input(_ inputCase: LevelOfMasteryServiceInput)
    func currentPoints() -> Int
}

class LevelOfMasteryService: NSObject, LevelOfMasteryServiceProtocol {
    
    static let shared = LevelOfMasteryService()
    
    private var levelsArray: [LevelBold] = []
    var currentLimit: LimitsLevel!
    
    private let changePointsVariable : BehaviorRelay<LevelInfoObserv> = BehaviorRelay(value: LevelInfoObserv(level: LevelBold(type: .apprentice), currentPoint: 0))
    var changePoints : Observable<LevelInfoObserv> {
        return changePointsVariable.asObservable()
    }
    
    var points = PointBold()
    
    private override init() {
        for type in LevelType.types {
            let level = LevelBold(type: type)
            self.levelsArray.append(level)
        }
        print("\(self.levelsArray)")
    }
    
    var levels: [LevelBold] {
        
        let currentLevel = getCurrentLevel()
        var updatedLevels = [LevelBold]()
        var isNextProgress = false
        var isOtherLevelsDisable = false
        for level in levelsArray {
            level.status = .active
            
            // Set Disable Levels
            if isOtherLevelsDisable {
                level.status = .disable
            }
            
            // Set Level in progress
            if isNextProgress {
                level.status = .progress
                isNextProgress = false
                isOtherLevelsDisable = true
            }
            
            // Set Active Levels
            if level.type == currentLevel.type {
                level.isCurrentLevel = true
                isNextProgress = true
            }
            
            updatedLevels.append(level)
        }
        return updatedLevels
    }
    
    
    func input(_ inputCase: LevelOfMasteryServiceInput) {
        
        switch inputCase {
        case .currentLevel(level: let levelCallback):
            getCurrentLevel(level: levelCallback)
        case .getAllLevels(levels: let levelsCallback):
            levelsCallback(levels)
        case .addPoints(points: let points):
            print("\(points)")
        case .deductPoints(points: let points):
            print("\(points)")
//        case .currentPoints(points: let pointsCallBack):
//            pointsCallBack(PointBold().currentPoints)
        }
    }
    
    
    // MARK: - Public funcs
    func getCurrentLevel() -> LevelBold {
        
        let points: Int = PointBold().currentPoints
        let achievedGoals: [Goal] = getAchievedGoals()
        
        let goalMidArray: [Goal] = achievedGoals.filter({ $0.timeSpentType == .mid })
        let goalLongArray: [Goal] = achievedGoals.filter({ $0.timeSpentType == .long })
        
        currentLimit = LimitsLevel(points: points, goalMid: goalMidArray.count, goalLong: goalLongArray.count)
        var currentLevel = levelsArray.first!
        
        for level in levelsArray {
            for limit in level.limits {

                if currentLimit.compare(limit: limit) {
                    currentLevel = level
                }
            }
        }
        
        currentLevel.status = .active
        return currentLevel
    }
    
    func currentPoints() -> Int {
       return PointBold().currentPoints
    }
    
    func getCurrentLevel(level: Callback<LevelBold>) {
        level(getCurrentLevel())
    }
    
    // MARK: - Private funcs
    func getAchievedGoals() -> [Goal] {
        return DataSource.shared.listLevelOfMasteryGoal()
    }
    
    func addPoints() {
        
        let levelInfoTest = LevelInfoObserv(level: getCurrentLevel(), currentPoint: PointBold().currentPoints)
        changePointsVariable.accept(levelInfoTest)
    }
}
