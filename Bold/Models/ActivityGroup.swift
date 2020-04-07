//
//  ActivityGroup.swift
//  Bold
//
//  Created by Alexander Kovalov on 24.03.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import SwiftyJSON

class ActivityGroup: ActivityBase {
//    var id: Int
    var name : String
//    var location : ContentType
    var contentObjects : [ActivityContent]
    
    init(id: Int, position: Int, type:ContentType, name: String, contentObjects: [ActivityContent]) {
        self.name = name
        self.contentObjects = contentObjects
        super.init(id: id, position: position, type: type)
    }
    
    static func mapJSON(_ json: JSON) -> ActivityGroup? {
        
        var typeString = json[ResponseKeys.type].stringValue
        
        if typeString.hasPrefix(ResponseKeys.typePrefix) {
            typeString = String(typeString.dropFirst(ResponseKeys.typePrefix.count))
        }
        
        var type : ContentType = .meditation
        
        if let checkType = ContentType(rawValue: typeString.lowercased()) {
            type = checkType
        }
        
//        guard let type = ContentType(rawValue: typeString.lowercased()) else { return nil }
        guard let groupArray = json[ResponseKeys.contentObjects].array else { return nil }
        let contentArray = groupArray.compactMap { ActivityContent.mapJSON($0) }
        
        return ActivityGroup(id: json[ResponseKeys.id].intValue,
                             position: json[ResponseKeys.position].intValue,
                             type: type,
                             name: json[ResponseKeys.name].stringValue,
                             contentObjects: contentArray)
    }
}

private struct ResponseKeys {
    static let id = "id"
    static let name = "name"
    static let position = "position"
    static let type = "location"
    static let typePrefix = "Content::"
    static let contentObjects = "content_objects"
}
