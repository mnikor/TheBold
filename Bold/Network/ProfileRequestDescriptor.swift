//
//  ProfileRequestDescriptor.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Alamofire

struct PinRequestDescriptor: RequestDescriptor {
    
    typealias ResponseType = String
    let profile: ProfileTemp
    
    var path: String {
        return "users/profile"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
}
