//
//  User+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/6/19.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var calendarOn: Bool
    @NSManaged public var downloadOnlyWifiOn: Bool
    @NSManaged public var iCloudOn: Bool
    @NSManaged public var levelOfMasteryPoints: Int32
    @NSManaged public var levelOfMasteryLevel: Int16
    @NSManaged public var token: String?
    @NSManaged public var firstOpenIdeas: Bool
    @NSManaged public var stakeInfo: Bool
    @NSManaged public var stakeContentInfo: Bool
    @NSManaged public var goalInfo: Bool
    @NSManaged public var premiumOn: Bool

}
