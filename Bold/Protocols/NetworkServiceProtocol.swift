//
//  NetworkServiceProtocol.swift
//  Bold
//
//  Created by Admin on 10/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkServiceProtocol: class {
    var baseURL: String { get }
    
    func sendRequest(endpoint: Endpoint,
                     method: HTTPMethod,
                     parameters: [String: Any],
                     headers: [String: String],
                     needUppendToken: Bool,
                     completion: ((Result<JSON>) -> Void)?)
}
