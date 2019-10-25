//
//  DaysOfWeek+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


public class DaysOfWeek: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .daysOfWeek)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
    func cloneInBackgroundContext() -> DaysOfWeek {
        let clone = DaysOfWeek()
        clone.friday = self.friday
        clone.monday = self.monday
        clone.saturday = self.saturday
        clone.sunday = self.sunday
        clone.thursday = self.thursday
        clone.tuesday = self.tuesday
        clone.wednesday = self.wednesday
        return clone
    }
    
}
