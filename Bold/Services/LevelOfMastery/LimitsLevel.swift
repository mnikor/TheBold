//
//  Limits.swift
//  Bold
//
//  Created by Alexander Kovalov on 05.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//


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
//struct LimitsLevel {
//    let points: Int
//    let goalMid: Int // 3-6 month
//    let goalLong: Int // <10 month
//    var description: String?
//    var completed: Bool
//
//    func compare(limit: LimitsLevel) -> Bool {
//
//        // Compare Points
//        guard self.points >= limit.points else { return false }
//
//        // Compare mid term Goals achieved or long use as mid term
//        if self.goalMid >= limit.goalMid || self.goalLong >= limit.goalMid {
//
//            // Compare long term Goals achieved
//            if self.goalLong >= limit.goalLong {
//
//                // Compare mid term Goals achieved
//                return limit.goalLong == 0 || self.goalMid >= limit.goalMid
//            }
//        }
//        return false
//    }
//}

struct LimitsLevel {
    var limitsPoint: [SimpleLevel]
    var completed: Bool = false
}

struct SimpleLevel {
    var completed: Bool = false
    let type: LimitType
    let description: String
    let isRequired: Bool = false
    
    func compare(limit: SimpleLevel) -> Bool {
        
        // Compare Points
        return self.type >= limit.type

    }
}
