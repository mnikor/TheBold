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
    var fileURL: String
    var imageURL: String?
    
    init(title: String?, key: String, fileURL: String, imageURL: String?) {
        self.title = title
        self.key = key
        self.fileURL = fileURL
        self.imageURL = imageURL
    }
    
    static func mapJSON(_ json: JSON) -> AnimateContent? {
        return AnimateContent.init(title: json[ResponseKeys.title].string,
                                     key: json[ResponseKeys.key].stringValue,
                                     fileURL: json[ResponseKeys.fileURL].stringValue,
                                     imageURL: json[ResponseKeys.imageURL].string)
    }
}

private struct ResponseKeys {
    static let title = "title"
    static let key = "key"
    static let fileURL = "animation_file_link"
    static let imageURL = "animation_thumb_link"
}
