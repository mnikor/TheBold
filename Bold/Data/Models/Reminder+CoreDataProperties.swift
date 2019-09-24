//
//  Reminder+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/22/19.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var type: Int16
    @NSManaged public var isSetTime: Bool
    @NSManaged public var timeInterval: Int32
    @NSManaged public var action: Action?

}
