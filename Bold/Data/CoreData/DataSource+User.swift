//
//  DataSource+User.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import CoreData

protocol UserFunctionality {
    func addUser()
    func updateUser()
    func deleteUser()
}

extension DataSource: UserFunctionality {
    func addUser() {
        
    }
    
    func updateUser() {
        
    }
    
    func deleteUser() {
        
    }
    
    func readUser() -> User? {
        
        var result : User?
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            result = try DataSource.shared.backgroundContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        return result
    }
    
}
