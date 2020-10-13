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
    
    init(title: String?, key: String, fileURL: String) {
        self.title = title
        self.key = key
        self.fileURL = fileURL
    }
    
    static func mapJSON(_ json: JSON) -> AnimateContent? {
        return AnimateContent.init(title: json[ResponseKeys.title].string,
                                     key: json[ResponseKeys.key].stringValue,
                                     fileURL: json[ResponseKeys.fileURL].stringValue)
    }
}

private struct ResponseKeys {
    static let title = "title"
    static let key = "key"
    static let fileURL = "animation_file_link"
}
