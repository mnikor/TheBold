//
//  ServerErrorFactory.swift
//  Bold
//
//  Created by Admin on 10/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
class ServerErrorFactory {
    
    static var unknown: ServerError {
        return ServerError(
            type: .unknown,
            title: ResponseErrorDescription.unknownTitle,
            description: ResponseErrorDescription.unknownDescription)
    }
    
    static var noInternetConnection: ServerError {
        return ServerError(
            type: .noInternetConnection,
            title: ResponseErrorDescription.noInternetConnectionTitle,
            description: ResponseErrorDescription.noInternetConnectionDescription)
    }
}

struct ResponseErrorDescription {
    static let unknownTitle = "Возникла ошибка"
    static let unknownDescription = "Попробуйте повторить через минуту"
    static let noInternetConnectionTitle = "Нет доступа к Интернету"
    static let noInternetConnectionDescription = "Проверьте подключение к интернету или повторите попытку"
}
