//
//  File+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


extension File {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<File> {
        return NSFetchRequest<File>(entityName: "File")
    }

    @NSManaged public var isAudio: Bool
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var name: String?
    @NSManaged public var path: String?
    @NSManaged public var sequence: Int16
    @NSManaged public var url: String?
    @NSManaged public var content: Content?

}
