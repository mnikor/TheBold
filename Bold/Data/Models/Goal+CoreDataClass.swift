//
//  Goal+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


public class Goal: NSManagedObject {

    var timeSpentType: GoalTimeSpentType {
        
        let startDate: Date = self.startDate != nil ? self.startDate! as Date : Date()
        let endDate: Date = self.endDate != nil ? self.endDate! as Date : Date()
        let monthSpent: Int = startDate.totalDistance(from: endDate, resultIn: .month) ?? 0
        
        switch monthSpent {
        case let s where s > 10:
            return .long
        case let s where s >= 3:
            return .mid
        default:
            return .short
        }
    }
    
    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .goal)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
}
