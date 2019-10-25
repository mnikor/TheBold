//
//  Action+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


public class Action: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .action)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
    func cloneInBackgroundContext() -> Action {
        let clone = Action()
        clone.id = clone.objectID.uriRepresentation().lastPathComponent
        clone.startDate = self.startDate
        clone.endDate = self.endDate
        clone.startDateType = self.startDateType
        clone.endDateType = self.endDateType
        clone.name = self.name
        clone.status = self.status
        clone.content = self.content
        clone.goal = self.goal
        clone.stake = self.stake
        clone.repeatAction = self.repeatAction != nil ? self.repeatAction!.cloneInBackgroundContext() : nil
        clone.reminderMe = self.reminderMe != nil ? self.reminderMe!.cloneInBackgroundContext() : nil
        return clone
    }
    
}
