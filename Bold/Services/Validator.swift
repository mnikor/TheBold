//
//  Validator.swift
//  Bold
//
//  Created by Admin on 05.12.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class Validator: ValidatorProtocol {
    
    // MARK: - Instance declaration
    
    static let shared = Validator()
    
    // MARK: - Life cycle
    
    private init() { }
    
    // MARK: - ValidatorProtocol
    
    func validate(text: String, type: TextFieldType) -> ValidationResult {
        switch type {
        case .email:
            return validateEmail(text)
        case .password:
            return validatePassword(text)
        }
    }
    
    // MARK: - Private methods
    
    private func validateEmail(_ email: String) -> ValidationResult {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) ? .valid : .invalid
    }
    
    private func validatePassword(_ password: String) -> ValidationResult {
        return password.count >= 6 ? .valid : .invalid
        // TODO: - change to 8 symbols
    }
    
}
