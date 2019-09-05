//
//  Content+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/4/19.
//
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var authorName: String?
    @NSManaged public var authorPhotoUrl: String?
    @NSManaged public var body: String?
    @NSManaged public var footer: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var isLock: Bool
    @NSManaged public var largeImage: String?
    @NSManaged public var likesCount: Int16
    @NSManaged public var pointsUnlock: Int16
    @NSManaged public var smallImage: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var actions: NSSet?
    @NSManaged public var files: NSSet?

}

// MARK: Generated accessors for actions
extension Content {

    @objc(addActionsObject:)
    @NSManaged public func addToActions(_ value: Action)

    @objc(removeActionsObject:)
    @NSManaged public func removeFromActions(_ value: Action)

    @objc(addActions:)
    @NSManaged public func addToActions(_ values: NSSet)

    @objc(removeActions:)
    @NSManaged public func removeFromActions(_ values: NSSet)

}

// MARK: Generated accessors for files
extension Content {

    @objc(addFilesObject:)
    @NSManaged public func addToFiles(_ value: File)

    @objc(removeFilesObject:)
    @NSManaged public func removeFromFiles(_ value: File)

    @objc(addFiles:)
    @NSManaged public func addToFiles(_ values: NSSet)

    @objc(removeFiles:)
    @NSManaged public func removeFromFiles(_ values: NSSet)

}
