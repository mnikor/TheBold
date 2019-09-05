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
    
}
