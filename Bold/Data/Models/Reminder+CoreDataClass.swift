//
//  Reminder+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/20/19.
//
//

import Foundation
import CoreData


public class Reminder: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .reminder)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
    func cloneInBackgroundContext() -> Reminder {
        let clone = Reminder()
        clone.type = self.type
        clone.isSetTime = self.isSetTime
        clone.timeInterval = self.timeInterval
        return clone
    }
}
