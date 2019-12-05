//
//  ValidatorProtocol.swift
//  Bold
//
//  Created by Admin on 05.12.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum TextFieldType {
    case email
    case password
}

enum ValidationResult {
    case valid
    case invalid
}

protocol ValidatorProtocol {
    func validate(text: String, type: TextFieldType) -> ValidationResult
}
