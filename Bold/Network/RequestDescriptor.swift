//
//  RequestDescriptor.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Alamofire

struct MediaParameters {
    let fileURL: URL
    let parameterName: String
    let fileName: String
    let mimeType: String
}

protocol RequestDescriptor {
    associatedtype ResponseType
    
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
    var mediaParameters: MediaParameters? { get }
}

extension RequestDescriptor {
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    var mediaParameters: MediaParameters? {
        return nil
    }
}
