//
//  File+CoreDataProperties.swift
//  
//
//  Created by Alexander Kovalov on 9/11/19.
//
//

import Foundation
import CoreData

enum FileType: Int16 {
    case pdf = 1
    case mp3
    case anim_video
    case anim_image
    case anim_json
}

extension File {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<File> {
        return NSFetchRequest<File>(entityName: "File")
    }

    @NSManaged public var type: Int16
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var name: String?
    @NSManaged public var path: String?
    @NSManaged public var sequence: Int16
    @NSManaged public var url: String?
    @NSManaged public var timeSpent: Int16
    @NSManaged public var content: Content?
    @NSManaged public var key: String?
    @NSManaged public var updatedAt: Date?

}
