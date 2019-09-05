//
//  DaysOfWeek+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


extension DaysOfWeek {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DaysOfWeek> {
        return NSFetchRequest<DaysOfWeek>(entityName: "DaysOfWeek")
    }

    @NSManaged public var friday: Bool
    @NSManaged public var monday: Bool
    @NSManaged public var saturday: Bool
    @NSManaged public var sunday: Bool
    @NSManaged public var thursday: Bool
    @NSManaged public var tuesday: Bool
    @NSManaged public var wednesday: Bool
    @NSManaged public var action: Action?

}
