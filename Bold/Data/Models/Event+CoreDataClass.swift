//
//  Event+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/16/19.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {

    var calculatePoints: Int {
        
        var points: Int = 0
        points = Int(self.stake) + PointsForAction.congratulationsAction
        
        if self.action?.content != nil {
            points = Int(self.stake) + PointsForAction.congratulationsWithContentAction
        }
        
        return points
    }
    
    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .event)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
}
