//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/16/19.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var endDate: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var reminderDate: NSDate?
    @NSManaged public var stake: Float
    @NSManaged public var startDate: NSDate?
    @NSManaged public var status: Int16
    @NSManaged public var action: Action?

}
