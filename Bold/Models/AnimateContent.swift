//
//  AnimationContent.swift
//  Bold
//
//  Created by Alexander Kovalov on 06.10.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnimateContent {
    
    var title: String?
    var key: String
    var fileURL: String?
    var imageURL: String?
//    var filePath: String?
//    var imagePath: String?
    var updatedAt: String
    
    init(title: String?, key: String, fileURL: String?, imageURL: String?, updatedAt: String) {
        self.title = title
        self.key = key
        self.fileURL = fileURL
        self.imageURL = imageURL
        self.updatedAt = updatedAt
    }
    
    static func mapJSON(_ json: JSON) -> AnimateContent? {
        return AnimateContent.init(title: json[ResponseKeys.title].string,
                                     key: json[ResponseKeys.key].stringValue,
                                     fileURL: json[ResponseKeys.fileURL].string,
                                     imageURL: json[ResponseKeys.imageURL].string,
//                                     filePath: json[ResponseKeys.filePath].string,
//                                     imagePath: json[ResponseKeys.imagePath].string,
                                     updatedAt: json[ResponseKeys.updatedAt].stringValue)
    }
}

private struct ResponseKeys {
    static let title = "title"
    static let key = "key"
    static let fileURL = "animation_file_link"
    static let imageURL = "animation_thumb_link"
//    static let filePath = "animation_file_path"
//    static let imagePath = "animation_thumb_path"
    static let updatedAt = "updated_at"
}
