//
//  Limits.swift
//  Bold
//
//  Created by Alexander Kovalov on 05.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

// MARK: LimitType

enum LimitType: Equatable {
    case points(Int)
    case goals(goalMid: Int, goalLong: Int)
    
    static public func == (lhs: LimitType, rhs: LimitType) -> Bool {
        switch (lhs, rhs) {
        case let (.points(a), .points(b)):
            return a == b
        case let (.goals(a, b), .goals(c, d)):
            return a==c && b == d
        default:
            return false
        }
    }
    
    static public func >= (lhs: LimitType, rhs: LimitType) -> Bool {
        switch (lhs, rhs) {
        case let (.points(a), .points(b)):
            return a >= b
        case let (.goals(a, b), .goals(c, d)):
            return a >= c && b >= d
        default:
            return false
        }
    }
}

// MARK: Level limits

struct LimitsLevel {
    var limitPoint: SimpleLimitLevel
    var limitsGoal: [SimpleLimitLevel]
    
    func getAllLimits() -> (points: Int, goalMid: Int, goalLong: Int) {
        
        var points : Int = 0
        var goalMid : Int = 0
        var goalLong : Int = 0
        
        if case .points(let pointsTemp) = self.limitPoint.type {
            points = pointsTemp
        }
        
        if self.limitsGoal.isEmpty == false {
            if case .goals(goalMid: let goalMidTemp, goalLong: let goalLongTemp) = self.limitsGoal.first!.type{
                goalMid = goalMidTemp
                goalLong = goalLongTemp
            }
        }
        
        return (points, goalMid, goalLong)
    }
}

// MARK: Simple Limit Level

struct SimpleLimitLevel {
    var completed: Bool = false
    let type: LimitType
    var description: String = ""
    
    func compare(limit: SimpleLimitLevel) -> Bool {
        return self.type >= limit.type
    }
}
