//
//  ServerError.swift
//  Bold
//
//  Created by Admin on 10/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ServerErrorType: Int {
    case unknown = -10000
    case noInternetConnection = -10001
}

struct ServerError: Error {
    
    // MARK: - Public variables
    
    var title: String
    var description: String
    var type: ServerErrorType
    
    // MARK: - Life cycle
    
    init?(type: Int, json: JSON) {
        guard let dictionary = json.dictionary,
            let title = dictionary[ErrorResponseKeys.title]?.string,
            let message = dictionary[ErrorResponseKeys.message]?.string else {
                return nil
        }
        self.type = ServerErrorType(rawValue: type) ?? .unknown
        self.title = title
        self.description = message
    }
    
    init(type: ServerErrorType, title: String, description: String) {
        self.type = type
        self.title = title
        self.description = description
    }
}

struct ErrorResponseKeys {
    static let title = "title"
    static let message = "message"
}
