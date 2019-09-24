//
//  Action+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/22/19.
//
//

import Foundation
import CoreData


extension Action {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var endDate: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var stake: Float
    @NSManaged public var startDate: NSDate?
    @NSManaged public var status: Int16
    @NSManaged public var startDateType: Int16
    @NSManaged public var endDateType: Int16
    @NSManaged public var content: Content?
    @NSManaged public var events: NSSet?
    @NSManaged public var goal: Goal?
    @NSManaged public var repeatAction: DaysOfWeek?
    @NSManaged public var reminderMe: Reminder?

}

// MARK: Generated accessors for events
extension Action {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
