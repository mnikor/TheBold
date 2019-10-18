//
//  Profile.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SwiftyJSON

class Profile: NSObject {
    var fullName: String? {
        if let firstName = firstName {
            if let lastName = lastName {
                return firstName + " " + lastName
            } else {
                return firstName
            }
        } else {
            return lastName
        }
    }
    
    var id : Int
    var email : String
    var status: String?
    var imageURL: String?
    var firstName: String?
    var lastName: String?
    
    init(id: Int, firstName: String?, lastName: String?, email:String, status: String? = nil, imageURL: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.status = status
        self.imageURL = imageURL
    }
    
    static func mapJSON(_ json: JSON) -> Profile? {
        guard let id = json[JSONKeys.id].int,
            let email = json[JSONKeys.email].string
            else { return nil }
        return Profile(id: id,
                       firstName: json[JSONKeys.firstName].string,
                       lastName: json[JSONKeys.lastName].string,
                       email: email,
                       status: json[JSONKeys.status].string,
                       imageURL: json[JSONKeys.imageURL].string)
    }
    
}

private struct JSONKeys {
    static let id = "id"
    static let email = "email"
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let status = "status"
    static let imageURL = "image_url"
}
