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
    case calculateProgress
    case currentLevel(level: Callback<LevelBold>)
    case getAllLevels(levels: Callback<[LevelBold]>)
    case checkAllGoalsAndAction
    case addPoints(points: Int)
    case unlockGoal(goalID: String)
}

protocol LevelOfMasteryServiceProtocol :class {
    func input(_ inputCase: LevelOfMasteryServiceInput)
}

class LevelOfMasteryService: NSObject, LevelOfMasteryServiceProtocol {
    
    static let shared = LevelOfMasteryService()
    
    private var levelsArray: [LevelBold] = []
    var currentLimit: LimitsLevel!
    
    private let changePointsVariable : BehaviorRelay<LevelInfoObserv> = BehaviorRelay(value: LevelInfoObserv(level: LevelBold(type: .apprentice), currentPoint: 0))
    
    var changePoints : Observable<LevelInfoObserv> {
        return changePointsVariable.asObservable()
    }
    
    private override init() {
        for type in LevelType.types {
            let level = LevelBold(type: type)
            self.levelsArray.append(level)
        }
    }
    
    var levels: [LevelBold] {
        
        let currentLevel = getCurrentLevel()
        var updatedLevels = [LevelBold]()
        var isOtherLevelsDisable = false
        for level in levelsArray {
            
            // Set Disable Levels
            if isOtherLevelsDisable {
                level.status = .disable
            }
            
            // Set Active Levels
            if level.type.rawValue < currentLevel.type.rawValue {
                level.status = .active
            }
            
            if level.type == currentLevel.type {
                level.status = .progress
                level.isCurrentLevel = true
                isOtherLevelsDisable = true
            }
            
            // check level limit
            
            if currentLimit.limitPoint.compare(limit: level.limits.limitPoint) {
                    
                level.limits.limitPoint.completed = true
                    
                var count = 0
                    for limit in level.limits.limitsGoal {
                        if  currentLimit.limitsGoal.first!.compare(limit: limit) {
                            level.limits.limitsGoal[count].completed = true
                        }
                        count += 1
                    }
                }
                
            updatedLevels.append(level)
        }
        return updatedLevels
    }
    
    func input(_ inputCase: LevelOfMasteryServiceInput) {
        
        switch inputCase {
        case .calculateProgress:
            calculateProgress()
        case .currentLevel(level: let levelCallback):
            getCurrentLevel(level: levelCallback)
        case .getAllLevels(levels: let levelsCallback):
            levelsCallback(levels)
        case .addPoints(points: let points):
            addPoints(points: points)
        case .unlockGoal(goalID: let goalID):
            unlockGoal(goalID: goalID)
        case .checkAllGoalsAndAction:
            checkAllEvents()
        }
    }
    
    
    // MARK: - Public funcs
    private func getCurrentLevel() -> LevelBold {
        
        let points: Int = currentPoints()
        let achievedGoals: [Goal] = getAchievedGoals()
        
        let goalMidArray: [Goal] = achievedGoals.filter({ $0.timeSpentType == .mid })
        let goalLongArray: [Goal] = achievedGoals.filter({ $0.timeSpentType == .long })
        
        currentLimit = LimitsLevel(limitPoint: SimpleLimitLevel(type: .points(points)),
                                   limitsGoal: [SimpleLimitLevel(type: .goals(goalMid: goalMidArray.count, goalLong: goalLongArray.count))])
        
        var currentLevel = levelsArray.first!
        
        for level in levelsArray {
            
            if currentLimit.limitPoint.compare(limit: level.limits.limitPoint) {
                
                if level.limits.limitsGoal.isEmpty {
                    currentLevel = level
                }
                
                for limit in level.limits.limitsGoal {
                    if currentLimit.limitsGoal.first!.compare(limit: limit) {
                        currentLevel = level
                    }
                }
            }
            
            if currentLevel.type != level.type {
                currentLevel = level
                break
            }
        }
        
        currentLevel.status = .active
        return currentLevel
    }
    
    private func currentPoints() -> Int {
        let pointsData = Int(DataSource.shared.readUser().levelOfMasteryPoints)
       return pointsData
    }
    
    private func getCurrentLevel(level: Callback<LevelBold>) {
        level(getCurrentLevel())
    }
    
    // MARK: - Private funcs
    private func getAchievedGoals() -> [Goal] {
        return DataSource.shared.listLevelOfMasteryGoal()
    }
    
    private func calculateProgress() {
        let levelInfoTest = LevelInfoObserv(level: getCurrentLevel(), currentPoint: currentPoints())
        changePointsVariable.accept(levelInfoTest)
    }
    
    private func addPoints(points: Int) {
        
        let user = DataSource.shared.readUser()
        var newPoint = (user.levelOfMasteryPoints) + Int32(points)
        
        if newPoint < 0 {
            newPoint = 0
        }
        user.levelOfMasteryPoints = newPoint
        DataSource.shared.saveBackgroundContext()
        
        calculateProgress()
    }
    
    private func checkAllEvents() {
        checkOverdueStatusEvents()
    }

    //проверяем все ивенты на то есть ли просроченные
    private func checkOverdueStatusEvents() {
        let events = DataSource.shared.searchOverdueEvents()
        
        if events.isEmpty {
            checkOverdueStatusActions()
            return
        }
        
        let _ = events.compactMap { (event) -> Event? in
            event.status = StatusType.failed.rawValue
            
            if let action = event.action {
                action.status = StatusType.failed.rawValue
                if let goal = action.goal {
                    goal.status = StatusType.locked.rawValue
                }
            }
            
            return event
        }
        
        AlertViewService.shared.input(.missedYourAction(tapOkay: {
            print("OK")
        }))
        
        DataSource.shared.saveBackgroundContext()
        checkOverdueStatusActions()
    }
    
    //проверяем все экшены на то есть ли просроченные
    private func checkOverdueStatusActions() {
        let actions = DataSource.shared.searchOverdueActions()
        
        if actions.isEmpty {
            checkOverdueStatusGoals()
            return
        }
        
        let _ = actions.compactMap { (action) -> Action? in
            action.status = StatusType.failed.rawValue
            
            if let goal = action.goal {
                goal.status = StatusType.locked.rawValue
            }
            
            return action
        }
        
        DataSource.shared.saveBackgroundContext()
        checkOverdueStatusGoals()
    }
    
    private func unlockGoal(goalID: String) {
//        DataSource.shared.searchGoal(goalID: goalID) { (goal) in
//            goal?.status = StatusType.wait.rawValue
//            DataSource.shared.saveBackgroundContext()
//        }
    }
    
    private func checkOverdueStatusGoals() {
        let goals = DataSource.shared.searchOverdueGoals()
        
        if goals.isEmpty {
            return
        }
        
        let _ = goals.compactMap { (goal) -> Goal? in
            goal.status = StatusType.failed.rawValue
            return goal
        }
        
        DataSource.shared.saveBackgroundContext()
    }
}
