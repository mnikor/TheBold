//
//  Action+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


extension Action {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var endDate: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var remindMe: NSDate?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var content: Content?
    @NSManaged public var goal: Goal?
    @NSManaged public var repeatAction: DaysOfWeek?

}
