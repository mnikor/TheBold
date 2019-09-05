//
//  Goal+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var color: Int16
    @NSManaged public var endDate: NSDate?
    @NSManaged public var icon: Int16
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var actions: NSSet?

}

// MARK: Generated accessors for actions
extension Goal {

    @objc(addActionsObject:)
    @NSManaged public func addToActions(_ value: Action)

    @objc(removeActionsObject:)
    @NSManaged public func removeFromActions(_ value: Action)

    @objc(addActions:)
    @NSManaged public func addToActions(_ values: NSSet)

    @objc(removeActions:)
    @NSManaged public func removeFromActions(_ values: NSSet)

}
